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
  ].join(" ");
  assertEquals(actual, expected);
});
