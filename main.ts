import * as fs from "std/fs";
import * as path from "std/path";

import alacritty from "./dot/alacritty.ts";
import bat from "./dot/bat.ts";
import chromiumFlags from "./dot/chromium.ts";
import curl from "./dot/curl.ts";
import git from "./dot/git.ts";
import glazewm from "./dot/glazewm.ts";
import goneovim from "./dot/goneovim.ts";
import hyprland from "./dot/hyprland.ts";
import lazygit from "./dot/lazygit.ts";
import neovim from "./dot/neovim.ts";
import paru from "./dot/paru.ts";
import { cargo, rustup } from "./dot/rust.ts";
import wofi from "./dot/wofi.ts";
import xremap from "./dot/xremap.ts";

const configs = [
  alacritty,
  bat,
  cargo,
  chromiumFlags,
  curl,
  git,
  glazewm,
  goneovim,
  hyprland,
  lazygit,
  neovim,
  paru,
  rustup,
  wofi,
  xremap,
];

async function main() {
  const hashListFile = path.join(Deno.cwd(), "hash_list.txt");
  if (!await fs.exists(hashListFile)) {
    await Deno.writeTextFile(hashListFile, "");
  }
  const oldHashList = await Deno.readTextFile(hashListFile);
  const newHashList = [];

  for (const config of configs) {
    if (config.enabled && !(await Promise.resolve(config.enabled()))) {
      continue;
    }
    for (const file of await Promise.resolve(config.files())) {
      const hash = await file.hash();
      newHashList.push(hash);
      if (!oldHashList.includes(hash)) {
        await file.write();
        console.log(file.doneMsg());
      }
    }
  }

  await Deno.writeTextFile(hashListFile, newHashList.join("\n"));
}

if (import.meta.main) {
  await main();
}
