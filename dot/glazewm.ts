import { $ } from "./deps/utils.ts";

import { Config, Yaml } from "../config.ts";
import { HOME_DIR } from "../path.ts";

function bind(command: string | string[], binding: string | string[]) {
  const result: {
    command?: string;
    commands?: string[];
    binding?: string;
    bindings?: string[];
  } = {};
  if (typeof command == "string") {
    result.command = command;
  } else {
    result.commands = command;
  }
  if (typeof binding == "string") {
    result.binding = binding;
  } else {
    result.bindings = binding;
  }
  return result;
}

const glazewm: Config = {
  enabled: () => !!HOME_DIR && $.commandExists("glazewm"),

  files: () => [
    new Yaml([
      HOME_DIR!,
      ".glaze-wm",
      "config.yaml",
    ], {
      general: {
        focus_follows_cursor: true,
        cursor_follows_focus: true,
        show_floating_on_top: true,
      },
      gaps: {
        inner_gap: 10,
        outer_gap: 8,
      },
      bar: {
        height: "19",
        position: "top",
        opacity: 1.0,
        background: "#000000",
        foreground: "#aaafb4",
        font_family: "IosevkaCustom Nerd Font",
        font_size: "15px",
        padding: "0",
        offset_x: "0",
        offset_y: "0",
        border_radius: "0",
        border_width: "0 8 0 8",
        border_color: "#61afef",
        components_left: [
          {
            type: "workspaces",
            focused_workspace_foreground: "#61afef",
            focused_workspace_background: "#000000",
            displayed_workspace_background: "transparent",
            default_workspace_foreground: "#51555f",
            padding: "0",
            margin: "0",
          },
        ],
        components_right: [
          {
            type: "tiling direction",
            label_horizontal: " ⮂ ",
            label_vertical: " ⮁ ",
          },
          {
            type: "binding mode",
            padding: "0 8px",
          },
          {
            type: "battery",
            label_draining: "  {battery_level}% ",
            label_power_saver: "  {battery_level}% ",
            label_charging: "  {battery_level}% ",
            foreground: "#000000",
            background: "#aaafb4",
          },
          {
            type: "clock",
            time_formatting: "  ddd MMM d ",
            foreground: "#aaafb4",
            background: "#2e334c",
          },
          {
            type: "clock",
            time_formatting: "  hh:mm tt",
            foreground: "#2e334c",
            background: "#61AFEF",
          },
        ],
      },
      workspaces: (() => {
        return [...Array(9)].map((_, i) => i + 1).map((i) => {
          return {
            name: i,
            display_name: i + " ",
          };
        });
      })(),
      window_rules: [
        {
          command: "ignore",
          match_process_name: "Taskmgr",
        },
        {
          command: "ignore",
          match_process_name: "ueli",
        },
        {
          command: "set floating",
          match_process_name: "7zFM",
        },
      ],
      binding_modes: [
        {
          name: "resize",
          keybindings: [
            bind("resize width +2%", ["L", "Right"]),
            bind("resize width -2%", ["H", "Left"]),
            bind("resize height +2%", ["K", "Up"]),
            bind("resize height -2%", ["J", "Down"]),
            bind("binding mode none", ["Escape", "Enter"]),
          ],
        },
      ],
      keybindings: [
        bind("binding mode resize", "Alt+R"),
        bind("tiling direction toggle", "Alt+V"),
        bind("toggle floating", "Alt+Space"),
        bind("focus mode toggle", "Alt+Shift+Space"),
        bind("toggle maximized", "Alt+M"),
        bind("set minimized", "Alt+X"),
        bind("close", "Alt+C"),
        bind("exit wm", "Alt+Shift+Q"),
        bind("reload config", "Alt+Shift+R"),
        bind("exec Vivaldi", "Alt+S"),
        bind(
          "exec %USERPROFILE%/scoop/apps/alacritty/current/alacritty.exe",
          "Alt+Enter",
        ),
        bind("focus workspace recent", "Alt+T"),
      ].concat(
        [
          bind("focus right", "Alt+L"),
          bind("focus left", "Alt+H"),
          bind("focus up", "Alt+K"),
          bind("focus down", "Alt+J"),
        ],
        (() => {
          return [...Array(9)].map((_, i) => i + 1).map((i) => {
            return bind("focus workspace " + i, "Alt+" + i);
          });
        })(),
        (() => {
          return [...Array(9)].map((_, i) => i + 1).map((i) => {
            return bind(
              ["move to workspace " + i, "focus workspace " + i],
              "Alt+Shift+" + i,
            );
          });
        })(),
      ),
    }),
  ],
};

export default glazewm;
