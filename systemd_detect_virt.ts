import { $ } from "@david/dax";

const command_exists = $.commandExists("systemd-detect-virt");

export async function isInContainerOrVM() {
  if (!await command_exists) {
    return false;
  }
  const res = await $`systemd-detect-virt -q --container --vm`.noThrow();
  return res.code == 0;
}

export async function isInChroot() {
  if (!await command_exists) {
    return false;
  }
  const res = await $`systemd-detect-virt -q --chroot`.noThrow();
  return res.code == 0;
}
