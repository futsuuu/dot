import { path } from "./deps/std.ts";

import { $ } from "./deps/utils.ts";

import { Config, Systemd, Yaml } from "../config.ts";

const xremap: Config = {
  enabled: () => $.commandExists("xremap"),

  files: () => {
    const configFile = path.join(
      Deno.env.get("XDG_CONFIG_HOME") as string,
      "xremap",
      "xremap.yml",
    );

    return [
      new Yaml(configFile, {
        modmap: [
          {
            name: "Global",
            remap: {
              CapsLock: "Control_L",
            },
          },
        ],
      }),
      new Systemd("xremap", {
        Unit: {
          Description: "xremap",
        },
        Service: {
          Type: "simple",
          ExecStart: `/usr/bin/xremap ${configFile}`,
          ExecStop: "/usr/bin/killall xremap",
          Restart: "always",
        },
        Install: {
          WantedBy: "multi-user.target",
        },
      }),
    ];
  },
};

export default xremap;
