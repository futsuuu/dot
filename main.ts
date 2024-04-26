import alacritty from "./dot/alacritty.ts";
import bat from "./dot/bat.ts";
import chromiumFlags from "./dot/chromium.ts";
import curl from "./dot/curl.ts";
import git from "./dot/git.ts";
import glazewm from "./dot/glazewm.ts";
import goneovim from "./dot/goneovim.ts";
import hyprland from "./dot/hyprland.ts";
import lazygit from "./dot/lazygit.ts";
import paru from "./dot/paru.ts";
import { cargo, rustup } from "./dot/rust.ts";
import wofi from "./dot/wofi.ts";
import xremap from "./dot/xremap.ts";

for (
  const config of [
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
    paru,
    rustup,
    wofi,
    xremap,
  ]
) {
  if (config.enabled && !(await Promise.resolve(config.enabled()))) {
    continue;
  }
  for (const file of await Promise.resolve(config.files())) {
    await file.write();
  }
}
