import * as fs from "jsr:@std/fs@1";

import { $ } from "jsr:@david/dax@0.43";

async function main() {
  $.setPrintCommand(true);
  if (await isInstallingArchLinux()) {
    if (!await isInChroot()) {
      $.logStep("Installing", "Arch Linux");
      await $.logGroup(async () => {
        const configOpts = JSON.stringify(await installArchLinux());
        await $`arch-chroot /mnt deno run -A ${import.meta.url} ${configOpts}`;
      });
      if (await $.confirm("Reboot now?", { default: true })) {
        $`reboot`;
      }
    } else {
      $.logStep("Configuring", "Arch Linux");
      await $.logGroup(async () => {
        const configOpts = JSON.parse(Deno.args[0]);
        await configureArchLinux(configOpts);
      });
    }
  } else {
    $.log("nothing to do :(");
    Deno.exit(1);
  }
}

interface ConfigOpts {
  targetDisk: string;
  rootVolume: string;
  bootPartition: number;
  systemPartition: number;
  hostName: string;
  rootUser: {
    password: string;
  };
  newUser: {
    name: string;
    password: string;
  };
}

async function installArchLinux(): Promise<ConfigOpts> {
  await $`timedatectl set-ntp true`;

  const targetDisk = await (async () => {
    const diskList = await getDiskList();
    if (diskList.length === 0) {
      $.logError("Disk not found");
      Deno.exit(1);
    }
    const index = await $.select({
      message: "Select the disk to install",
      options: diskList,
    });
    return diskList[index];
  })();
  const luksPassword = await passwordPrompt("LUKS");
  const rootPassword = await passwordPrompt("root user");
  const newUserName = await $.prompt("Enter a new user name:");
  const newUserPassword =
    await $.confirm("Do you want to use the same password as root?", {
        default: true,
      })
      ? rootPassword
      : await passwordPrompt(newUserName);

  if (
    !await isInContainerOrVM() &&
    await $.confirm("Do you want to cleanup the disk?", { default: false })
  ) {
    await $`cryptsetup open --type plain ${targetDisk} container --key-file /dev/random`;
    await $`dd if=/dev/zero of=/dev/mapper/container bs=8M status=progress`
      .noThrow();
    await $`cryptsetup close container`;
  }

  $.logStep("Partitioning", targetDisk);
  const partitions = await $.logGroup(async () => {
    // EFI system
    const boot = getPartitionPath(targetDisk, 1);
    await $`sgdisk --new 0::+1G --typecode 0:ef00 --change-name 0:boot ${targetDisk}`;
    // Linux LVM
    const system = getPartitionPath(targetDisk, 2);
    await $`sgdisk --new 0:: --typecode 0:8e00 --change-name 0:system ${targetDisk}`;

    return { boot, system } as const;
  });

  $.logStep("Creating", "LUKS container");
  const luksContainer = await $.logGroup(async () => {
    const containerName = "cryptolvm";
    await $`cryptsetup luksFormat ${partitions.system} --key-file -`
      .stdinText(luksPassword);
    await $`cryptsetup open --type luks ${partitions.system} ${containerName} --key-file -`
      .stdinText(luksPassword);
    return `/dev/mapper/${containerName}` as const;
  });

  $.logStep("Setting up", "LVM");
  const logicalVolumes = await $.logGroup(async () => {
    await $`pvcreate ${luksContainer}`;

    const vg = "system";
    await $`vgcreate ${vg} ${luksContainer}`;

    await $`lvcreate -L ${Deno.systemMemoryInfo().total}B ${vg} -n swap`;
    await $`lvcreate -l 25%FREE ${vg} -n root`;
    await $`lvcreate -l 100%FREE ${vg} -n home`;

    return {
      root: `/dev/${vg}/root`,
      home: `/dev/${vg}/home`,
      swap: `/dev/${vg}/swap`,
    } as const;
  });

  $.logStep("Formatting", "partitions");
  await $.logGroup(async () => {
    await $`mkfs.ext4 ${logicalVolumes.root}`;
    await $`mkfs.ext4 ${logicalVolumes.home}`;
    await $`mkfs.fat -F 32 ${partitions.boot}`;
    await $`mkswap ${logicalVolumes.swap}`;
  });

  $.logStep("Mounting", "filesystems");
  await $.logGroup(async () => {
    await $`mount ${logicalVolumes.root} /mnt`;
    await $`mount --mkdir ${logicalVolumes.home} /mnt/home`;
    await $`mount --mkdir -o fmask=0137,dmask=0027 ${partitions.boot} /mnt/boot`;
    await $`swapon ${logicalVolumes.swap}`;
    await $`genfstab -U /mnt >> /mnt/etc/fstab`;
  });

  $.logStep("Executing", "pacstrap");
  await $.logGroup(async () => {
    const pkgs = [
      "base",
      "base-devel",
      "linux",
      "lvm2",
      "efibootmgr",
      "sudo",
      "networkmanager",
      "deno",
    ];
    if (!await isInContainerOrVM()) {
      pkgs.push("linux-firmware");
      const cpuinfo = await Deno.readTextFile("/proc/cpuinfo");
      if (cpuinfo.includes("AuthenticAMD")) {
        pkgs.push("amd-ucode");
      } else if (cpuinfo.includes("GenuineIntel")) {
        pkgs.push("intel-ucode");
      }
    }
    await $`pacstrap -K /mnt ${pkgs}`;
  });

  return {
    targetDisk: targetDisk,
    rootVolume: logicalVolumes.root,
    bootPartition: 1,
    systemPartition: 2,
    hostName: "myarchlinux",
    rootUser: {
      password: await hashPassword(rootPassword),
    },
    newUser: {
      name: newUserName,
      password: await hashPassword(newUserPassword),
    },
  };
}

async function configureArchLinux(opts: ConfigOpts) {
  $.logStep("Configuring", "users");
  await $.logGroup(async () => {
    await $`usermod --password ${opts.rootUser.password} root`;
    await $`useradd --create-home --gid users --groups wheel --shell /bin/bash --password ${opts.newUser.password} ${opts.newUser.name}`;
    await Deno.writeTextFile(
      "/etc/sudoers.d/wheel",
      "%wheel ALL=(ALL:ALL) ALL",
    );
  });
}

function hashPassword(password: string) {
  return $`openssl passwd -6 -salt $(openssl rand -base64 12) -stdin`
    .stdinText(password)
    .text();
}

async function passwordPrompt(name: string) {
  while (true) {
    const password = await $.prompt(
      `Enter a new password of ${name}:`,
      { mask: true },
    );
    const reentered = await $.prompt(
      "Re-enter the password for confirmation:",
      { mask: true },
    );
    if (reentered === password) {
      return password;
    }
    $.logError("Password mismatch");
  }
}

async function getDiskList() {
  const stdout =
    await $`lsblk --filter 'TYPE=="disk"' --output PATH --noheadings`.text();
  return stdout.split("\n");
}

function getPartitionPath(disk: string, n: number) {
  return (disk.startsWith("/dev/nvme") || disk.startsWith("/dev/mmcblk"))
    ? `${disk}p${n}`
    : `${disk}${n}`;
}

function isInstallingArchLinux() {
  return fs.exists("/run/archiso");
}

async function isInContainerOrVM() {
  const res = await $`systemd-detect-virt -q --container --vm`.noThrow();
  return res.code == 0;
}

async function isInChroot() {
  const res = await $`systemd-detect-virt -q --chroot`.noThrow();
  return res.code == 0;
}

if (import.meta.main) {
  await main();
}
