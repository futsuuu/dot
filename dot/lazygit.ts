import { $ } from "./deps/utils.ts";

import { Config, Yaml } from "../config.ts";
import { LOCALAPPDATA } from "../path.ts";

const lazygit: Config = {
  enabled: () => !!LOCALAPPDATA && $.commandExists("lazygit"),

  files: () => [
    new Yaml([LOCALAPPDATA!, "lazygit", "config.yml"], {
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
