import * as path from "std/path";

import { $ } from "dax";

import { LOCALAPPDATA, PRJROOT } from "../path.ts";
import { Config, Link } from "../config.ts";

const neovim: Config = {
  enabled: () => $.commandExists("nvim"),
  files: () => [
    new Link([LOCALAPPDATA, "nvim"], path.join(PRJROOT, "dot", "neovim")),
  ],
};

export default neovim;
