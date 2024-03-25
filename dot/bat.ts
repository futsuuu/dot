import { $ } from "dax";

import { Config, Flag } from "../config.ts";

const bat: Config = {
  enabled: () => $.commandExists("bat"),

  files: async () => [
    new Flag(await $`bat --config-file`.text(), {
      theme: "TwoDark",
      style: ["numbers", "changes", "header"],
      color: "always",
    }),
  ],
};

export default bat;
