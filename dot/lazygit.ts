import { $ } from "./deps/utils.ts";

import { Config, Yaml } from "../config.ts";

const lazygit: Config = {
  enabled: () => $.commandExists("lazygit"),

  files: () => [
    new Yaml([
      Deno.env.get("LOCALAPPDATA") || Deno.env.get("XDG_CONFIG_HOME") as string,
      "lazygit",
      "config.yml",
    ], {
      gui: {
        language: "en",
        showRandomTip: false,
        showIcons: true,
        theme: {
          activeBorderColor: ["blue", "bold"],
          inactiveBorderColor: ["darkgray"],
        },
      },
    }),
  ],
};

export default lazygit;
