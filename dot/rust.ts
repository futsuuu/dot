import * as path from "std/path";

import { $ } from "dax";

import { Config, Toml } from "../config.ts";
import { HOME_DIR } from "../path.ts";

const rustup: Config = {
  files: () => [
    new Toml([
      HOME_DIR ? path.join(HOME_DIR, ".rustup") : "/etc/rustup",
      "settings.toml",
    ], {
      version: "12",
      default_toolchain: "stable-" + Deno.build.target,
    }),
  ],
};

const cargo: Config = {
  enabled: () => !!HOME_DIR && $.commandExists("cargo"),

  files: () => [
    new Toml([HOME_DIR!, ".cargo", "config.toml"], {
      alias: {
        a: "add",
        i: "init",
        n: "new",
        br: "build --release",
        rr: "run --release",
      },
      http: {
        "check-revoke": Deno.build.os != "windows",
      },
    }),
  ],
};

export { cargo, rustup };
