import { Config, Flag } from "../config.ts";
import { CONFIG_DIR } from "../path.ts";

const chromiumFlags: Config = {
  enabled: () => {
    const env = Deno.env.get("XDG_SESSION_TYPE");
    return env ? env == "wayland" : false;
  },

  files: () => {
    return [
      "electron-flags.conf",
      "code-flags.conf",
      "vivaldi-stable.conf",
    ].map((name) => {
      return new Flag([CONFIG_DIR, name], {
        enable_features: "WaylandWindowDecorations",
        ozone_platform_hint: "auto",
        gtk_version: "4",
      });
    });
  },
};

export default chromiumFlags;
