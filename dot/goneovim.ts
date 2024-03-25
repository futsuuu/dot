import { $ } from "./deps/utils.ts";
import { CONFIG_DIR } from "../path.ts";

import { Config, Toml } from "../config.ts";

const goneovim: Config = {
  enabled: () => $.commandExists("goneovim"),

  files: () => [
    new Toml([CONFIG_DIR, "goneovim", "settings.toml"], {
      Cursor: {
        SmoothMove: true,
      },
      Editor: {
        BorderlessWindow: false,
        HideTitlebar: false,
        StartFullscreen: false,
        StartMaximizedWindow: true,
        Transparent: 1,
        RestoreWindowGeometry: false,
        WindowGeometryBasedOnFontmetrics: false,

        ExtCmdline: false,
        ExtMessages: false,
        ExtPopupmenu: false,
        ExtTabline: false,
        ClickEffect: false,
        DrawBorderForFloatWindow: false,
        DrawShadowForFloatWindow: false,
        IndentGuide: false,

        Clipboard: true,
        ModeEnablingIME: [],
        HideMouseWhenTyping: true,
        IgnoreSaveConfirmationWithCloseButton: false,

        FontFamily: "IosevkaCustom Nerd Font",
        FontSize: 10,
        DisableLigatures: false,

        SmoothScroll: false,
        SmoothScrollDuration: 300,
        DisableHorizontalScroll: true,
        MouseScrollingUnit: "line",
      },
    }),
  ],
};

export default goneovim;
