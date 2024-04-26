import { $ } from "dax";

import { Config, Pacman } from "../config.ts";
import { CONFIG_DIR, HOME_DIR } from "../path.ts";

const paru: Config = {
  enabled: () => $.commandExists("paru"),

  files: () => [
    new Pacman(
      HOME_DIR ? [CONFIG_DIR, "paru", "paru.conf"] : [CONFIG_DIR, "paru.conf"],
      {
        // general options
        options: {
          PgpFetch: true,
          Devel: true,
          Provides: true,
          DevelSuffixes: "-git -cvs -svn -bzr -darcs -always -hg -fossil",
          AurOnly: false,
          BottomUp: true,
          RemoveMake: "ask",
          SudoLoop: false,
          UseAsk: false,
          SaveChanges: false,
          CombinedUpgrade: false,
          CleanAfter: true,
          UpgradeMenu: false,
          NewsOnUpgrade: false,

          LocalRepo: false,
          Chroot: false,
          Sign: false,
          SignDb: false,
          KeepRepoCache: false,
        },
        // binary options
        // bin: {
        //   FileManager: "vifm",
        //   MFlags: "--skippgpcheck",
        //   Sudo: "doas",
        // },
      },
    ),
  ],
};

export default paru;
