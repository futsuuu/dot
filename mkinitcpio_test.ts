import { assertEquals } from "@std/assert";

import * as mkinitcpio from "./mkinitcpio.ts";

Deno.test(function generateConfig() {
  const actual = mkinitcpio.generateConfig({
    modules: ["tpm_tis?"],
    binaries: ["kexec"],
    files: ["/etc/modprobe.d/modprobe.conf"],
    hooks: ["systemd", "udev"],
    compression: "lz4",
  });
  const expected = `\
MODULES=(tpm_tis?)
BINARIES=(kexec)
FILES=(/etc/modprobe.d/modprobe.conf)
HOOKS=(systemd udev)
COMPRESSION="lz4"
`;
  assertEquals(actual, expected);
});

Deno.test(function generatePreset() {
  const actual = mkinitcpio.generatePreset({
    all: {
      kver: "/boot/vmlinuz-linux-lts",
    },
    presets: {
      default: {
        uki: "/boot/EFI/Linux/arch-lts.efi",
        splash: "/usr/share/systemd/bootctl/splash-arch.bmp",
      },
      fallback: {
        uki: "/boot/EFI/Linux/arch-lts-fallback.efi",
        options: "-S autodetect",
      },
    },
  });
  const expected = `\
ALL_kver='/boot/vmlinuz-linux-lts'
PRESETS=('default' 'fallback')
default_splash='/usr/share/systemd/bootctl/splash-arch.bmp'
default_uki='/boot/EFI/Linux/arch-lts.efi'
fallback_options='-S autodetect'
fallback_uki='/boot/EFI/Linux/arch-lts-fallback.efi'
`;
  assertEquals(actual, expected);
});

Deno.test(function generateKernelParams() {
  const actual = mkinitcpio.generateKernelParams([
    {
      root: "/dev/system/root",
      rw: true,
      quiet: true,
      splash: true,
      "rd.luks": {
        name: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX=lukscontainer",
        options: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX=password-echo=no",
      },
    },
  ]);
  const expected = [
    "quiet",
    "rd.luks.name=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX=lukscontainer",
    "rd.luks.options=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX=password-echo=no",
    "root=/dev/system/root",
    "rw",
    "splash",
  ].join(" ") + "\n";
  assertEquals(actual, expected);
});
