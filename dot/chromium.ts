import { path } from "./deps/std.ts";

import { Config, Flag } from "../config.ts";

const chromiumFlags: Config = {
  enabled: () => {
    const env = Deno.env.get("XDG_SESSION_TYPE");
    return env ? env == "wayland" : false;
  },

  files: () => {
    const homeDir = Deno.env.get("HOME");
    const configDir = homeDir ? path.join(homeDir, ".config") : "/etc";
    return [
      "electron-flags.conf",
      "code-flags.conf",
      "vivaldi-stable.conf",
    ].map((name) => {
      return new Flag([configDir, name], {
        enable_features: "WaylandWindowDecorations",
        ozone_platform_hint: "auto",
        gtk_version: "4",
      });
    });
  },
};

export default chromiumFlags;
