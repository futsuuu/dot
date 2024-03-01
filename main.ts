import alacritty from "./dot/alacritty.ts";
import bat from "./dot/bat.ts";
import chromiumFlags from "./dot/chromium.ts";
import curl from "./dot/curl.ts";
import glazewm from "./dot/glazewm.ts";
import lazygit from "./dot/lazygit.ts";

for (const config of [alacritty, bat, chromiumFlags, curl, glazewm, lazygit]) {
  if (config.enabled && !(await Promise.resolve(config.enabled()))) {
    continue;
  }
  for (const file of await Promise.resolve(config.files())) {
    await file.write();
  }
}
