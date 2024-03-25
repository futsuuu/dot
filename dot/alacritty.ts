import { $ } from "dax";

import { Config, Toml } from "../config.ts";
import { APPDATA } from "../path.ts";

const alacritty: Config = {
  enabled: () => $.commandExists("alacritty"),

  files: () => [
    new Toml([
      APPDATA,
      "alacritty",
      "alacritty.toml",
    ], {
      live_config_reload: false,
      shell: {
        program: "nu",
        args: ["--login"],
      },
      window: {
        decorations: "full",
        dynamic_padding: true,
        opacity: 1.0,
      },
      bell: {
        animation: "EaseOutExpo",
        color: "#ffffff",
        command: "None",
        duration: 0,
      },
      colors: {
        draw_bold_text_with_bright_colors: false,
        primary: {
          background: "#24283b",
          foreground: "#a9b1d6",
        },
        bright: {
          black: "#444b6a",
          blue: "#7da6ff",
          cyan: "#2ccee3",
          green: "#b9f27c",
          magenta: "#bb9af7",
          red: "#ff7a93",
          white: "#b5c6da",
          yellow: "#ff9e64",
        },
        normal: {
          black: "#1f2335",
          blue: "#7aa2f7",
          cyan: "#58acc7",
          green: "#9ece6a",
          magenta: "#ad8ee6",
          red: "#f7768e",
          white: "#829398",
          yellow: "#e0af68",
        },
      },
      cursor: {
        vi_mode_style: "Block",
        style: {
          blinking: "Off",
          shape: "Beam",
        },
      },
      debug: {
        log_level: "Warn",
      },
      font: {
        builtin_box_drawing: true,
        size: 10,
        normal: {
          family: "IosevkaCustom Nerd Font",
          style: "Regular",
        },
        italic: {
          family: "IosevkaCustom Nerd Font",
          style: "Italic",
        },
        bold: {
          family: "IosevkaCustom Nerd Font",
          style: "Bold",
        },
        bold_italic: {
          family: "IosevkaCustom Nerd Font",
          style: "Bold Italic",
        },
        glyph_offset: {
          x: 0,
          y: 0,
        },
      },
      hints: {
        enabled: [
          {
            command: (() => {
              switch (Deno.build.os) {
                case "darwin":
                  return "open";
                case "windows":
                  return { program: "cmd", args: ["/c", "start", ""] };
                default:
                  return "xdg-open";
              }
            })(),
            hyperlinks: true,
            post_processing: true,
            mouse: { enabled: true, mods: "None" },
            regex:
              '(ipfs:|ipns:|mailto:|https:|http:|file:|git:|ssh:|ftp:)[^\u{0000}-\u{001F}<>"\\s{-}\\^⟨⟩`]+',
          },
        ],
      },
      keyboard: {
        bindings: [
          {
            action: "Paste",
            key: "V",
            mode: "~Vi",
            mods: "Control|Shift",
          },
          {
            action: "Copy",
            key: "C",
            mods: "Control|Shift",
          },
          {
            action: "ResetFontSize",
            key: "Key0",
            mods: "Control",
          },
          {
            action: "IncreaseFontSize",
            key: "Equals",
            mods: "Control",
          },
          {
            action: "DecreaseFontSize",
            key: "Minus",
            mods: "Control",
          },
        ],
      },
      mouse: {
        hide_when_typing: true,
      },
      scrolling: {
        history: 10000,
        multiplier: 3,
      },
      selection: {
        save_to_clipboard: false,
        semantic_escape_chars: ",│`|:\"' ()[]{}<>\t",
      },
    }),
  ],
};

export default alacritty;
