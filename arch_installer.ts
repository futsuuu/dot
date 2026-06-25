import { $ } from "@david/dax";

import * as mkinitcpio from "./mkinitcpio.ts";

if (import.meta.main) {
  await main();
}

async function main() {
  $.setPrintCommand(true);
  if (!await isInChroot()) {
    $.logStep("Installing", "Arch Linux");
    await $.logGroup(async () => {
      const configOpts = JSON.stringify(await installArchLinux());
      $.logStep("Entering", "chroot environment");
      const tempDir = "/var/tmp/arch_installer";
      await Deno.mkdir(`/mnt${tempDir}`, { recursive: true });
      await Deno.copyFile(Deno.execPath(), `/mnt${tempDir}/deno`);
      await Deno.copyFile(new URL(import.meta.url), `/mnt${tempDir}/main.js`);
      // https://github.com/systemd/systemd/issues/39002
      await $`arch-chroot -S /mnt ${tempDir}/deno run -A ${tempDir}/main.js ${configOpts}`;
      await Deno.remove(`/mnt${tempDir}`, { recursive: true });
    });
    if (await $.confirm("Reboot now?", { default: true })) {
      await $`reboot`;
    }
  } else {
    $.logStep("Configuring", "Arch Linux");
    await $.logGroup(async () => {
      const configOpts = JSON.parse(Deno.args[0]);
      await configureArchLinux(configOpts);
    });
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
  const targetDisk = await (async () => {
    const diskList = await getDiskList();
    if (diskList.length === 0) {
      $.logError("Disk not found");
      Deno.exit(1);
    }
    const selected = await $.select({
      message: "Select the disk to install",
      options: diskList,
    });
    return selected.value;
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
    return {
      name: containerName,
      device: partitions.system,
      mapper: `/dev/mapper/${containerName}`,
    } as const;
  });

  $.logStep("Setting up", "LVM");
  const logicalVolumes = await $.logGroup(async () => {
    await $`pvcreate ${luksContainer.mapper}`;

    const vg = "system";
    await $`vgcreate ${vg} ${luksContainer.mapper}`;

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

    await Deno.mkdir("/mnt/etc", { recursive: true });
    await $`genfstab -U /mnt >> /mnt/etc/fstab`;
  });

  const kernel: LinuxKernel = "linux";

  $.logStep("Configuring", "mkinitcpio");
  await $.logGroup(async () => {
    await Deno.writeTextFile(
      "/mnt/etc/mkinitcpio.conf",
      mkinitcpio.generateConfig({
        modules: ["tpm_tis?"],
        binaries: [],
        files: [],
        hooks: [
          "base",
          "systemd",
          "autodetect",
          "microcode",
          "modconf",
          "kms",
          "keyboard",
          "sd-vconsole",
          "block",
          "sd-encrypt",
          "lvm2",
          "filesystems",
          "fsck",
        ],
        compression: "lz4",
        compressionOptions: ["-9"],
      }),
    );
    await Deno.writeTextFile("/mnt/etc/vconsole.conf", "");

    await Deno.mkdir("/mnt/etc/cmdline.d", { recursive: true });
    const luksContainerUuid = await getUuid(luksContainer.device);
    await Deno.writeTextFile(
      "/mnt/etc/cmdline.d/root.conf",
      mkinitcpio.generateKernelParams([
        {
          root: logicalVolumes.root,
          rw: true,
          quiet: true,
          bgrt_disable: true,
          "rd.luks": {
            name: `${luksContainerUuid}=${luksContainer.name}`,
            options: `${luksContainerUuid}=tpm2-device=auto`,
          },
        },
      ]),
    );

    await Deno.mkdir("/mnt/etc/mkinitcpio.d", { recursive: true });
    await Deno.writeTextFile(
      `/mnt/etc/mkinitcpio.d/${kernel}.preset`,
      mkinitcpio.generatePreset({
        all: {
          kver: `/boot/vmlinuz-${kernel}`,
        },
        presets: {
          default: {
            uki: `/boot/EFI/Linux/arch-${kernel}.efi`,
            options: "--splash=/usr/share/systemd/bootctl/splash-arch.bmp",
          },
          fallback: {
            uki: `/boot/EFI/Linux/arch-${kernel}-fallback.efi`,
            options: "-S autodetect",
          },
        },
      }),
    );

    await Deno.mkdir("/mnt/boot/EFI/Linux", { recursive: true });
  });

  $.logStep("Executing", "pacstrap");
  await $.logGroup(async () => {
    const pkgs = [
      "base",
      "base-devel",
      kernel,
      "mkinitcpio",
      "lz4",
      "lvm2",
      // "efibootmgr",
      "sudo",
      "iwd",
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
    targetDisk,
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
  $.logStep("Applying", "account settings");
  await $.logGroup(async () => {
    await $`usermod ${[
      "--password",
      opts.rootUser.password,
      "root",
    ]}`;
    await $`useradd ${[
      "--create-home",
      "--gid",
      "users",
      "--groups",
      "wheel",
      "--shell",
      "/bin/bash",
      "--password",
      opts.newUser.password,
      opts.newUser.name,
    ]}`;
    await Deno.writeTextFile(
      "/etc/sudoers.d/wheel",
      "%wheel ALL=(ALL:ALL) ALL\n",
    );
    await Deno.writeTextFile("/etc/hostname", opts.hostName + "\n");
  });

  $.logStep("Setting", "locale and time zone");
  await $.logGroup(async () => {
    await Deno.symlink("/usr/share/zoneinfo/Asia/Tokyo", "/etc/localtime");
    await $`hwclock --systohc`;

    await Deno.writeTextFile(
      "/etc/locale.gen",
      "en_US.UTF-8 UTF-8\n" + "ja_JP.UTF-8 UTF-8\n",
      { append: true },
    );
    await $`locale-gen`;
    await Deno.writeTextFile("/etc/locale.conf", "LANG=en_US.UTF-8\n");
  });

  await $`bootctl --variables=yes install`;
  // await $`efibootmgr ${[
  //   "--create",
  //   "--disk",
  //   opts.targetDisk,
  //   "--part",
  //   opts.bootPartition,
  //   "--label",
  //   "Arch Linux",
  //   "--loader",
  //   "\\EFI\\Linux\\arch-linux.efi",
  //   "--unicode",
  // ]}`;
}

type LinuxKernel =
  | "linux"
  | "linux-hardened"
  | "linux-lts"
  | "linux-rt"
  | "linux-rt-lts"
  | "linux-zen";

async function hashPassword(password: string) {
  const salt = await $`openssl rand -base64 12`.text();
  return await $`openssl passwd -6 -salt ${salt} -stdin`
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

function getUuid(device: string) {
  return $`lsblk --filter 'PATH=="${device}"' --output UUID --noheadings`
    .text();
}

function getPartitionPath(disk: string, n: number) {
  return (disk.startsWith("/dev/nvme") || disk.startsWith("/dev/mmcblk"))
    ? `${disk}p${n}`
    : `${disk}${n}`;
}

async function isInContainerOrVM() {
  const res = await $`systemd-detect-virt -q --container --vm`.noThrow();
  return res.code == 0;
}

async function isInChroot() {
  const res = await $`systemd-detect-virt -q --chroot`.noThrow();
  return res.code == 0;
}
