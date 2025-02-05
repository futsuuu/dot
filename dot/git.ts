import { $ } from "dax";

import { Config, Git } from "../config.ts";
import { CONFIG_DIR, HOME_DIR } from "../path.ts";

const config: Record<string, Record<string, string | string[]>> = {
  include: {
    path: Deno.build.os == "windows" ? [".gitconfig_local"] : ["config_local"],
  },
  user: {
    name: "futsuuu",
    email: "futsuuu123@gmail.com",
  },
  core: {
    editor: "nvim",
    autocrlf: "input",
    commentChar: ";",
  },
  alias: {
    i: "init",
    a: "add",
    br: "branch",
    cm: "commit",
    cma: "commit --amend",
    df: "diff",
    ps: "push",
    pst: "push --tags",
    pl: "pull",
    st: "status --short --branch",
    lg: "log --oneline --graph --decorate",
    rs: "restore",
    sw: "switch",
    fc: "fetch",
    mg: "merge",
    tg: "tag",
    cf: "config",
    cfl: "config --local",
    sh: "stash",
  },
  'credential "helperselector"': {
    selected: "<no helper>",
  },
  'filter "lfs"': {
    clean: "git-lfs clean -- %f",
    smudge: "git-lfs smudge -- %f",
    process: "git-lfs filter-process",
    required: "true",
  },
  init: {
    defaultBranch: "main",
  },
  diff: {
    algorithm: "histogram",
    colorMoved: "dimmed-zebra",
  },
  commit: {
    verbose: "true",
  },
  merge: {
    ff: "false",
  },
  pull: {
    ff: "only",
  },
  fetch: {
    prune: "true",
  },
  push: {
    default: "current",
  },
  color: {
    ui: "true",
  },
};

if (await $.commandExists("gh")) {
  const helper = ["", "!gh auth git-credential"];
  config['credential "https://github.com"'] = { helper: helper };
  config['credential "https://gist.github.com"'] = { helper: helper };
}

if (await $.commandExists("grm")) {
  config.grm = {
    root: "~/dev",
  };
}

const git: Config = {
  files: () => [
    new Git(
      Deno.build.os == "windows"
        ? [HOME_DIR!, ".gitconfig"]
        : [CONFIG_DIR, "git", "config"],
      config,
    ),
  ],
};

export default git;
