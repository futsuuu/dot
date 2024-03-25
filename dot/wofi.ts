import { path } from "./deps/std.ts";

import { $ } from "./deps/utils.ts";

import { Config, Ini, Text } from "../config.ts";
import { CONFIG_DIR } from "../path.ts";

const css = `
* {
  font-family: "IosevkaCustom Nerd Font";
  font-size: 15px;
  font-weight: 500;
}

#window {
  background-color: --wofi-color0;
  color: --wofi-color2;
  border: 0px solid --wofi-color1;
  border-radius: 12px;
}

#outer-box {
  padding: 10px;
}

#input {
  font-weight: 600;
  font-size: 16px;
  background-color: --wofi-color1;
  border: 0px solid --wofi-color3;
  padding: 4px 12px;
}

#scroll {
  margin-top: 10px;
}

#inner-box {
}

#img {
  padding-right: 8px;
}

#text {
  color: --wofi-color2;
}

#text:selected {
  color: --wofi-color0;
}

#entry {
  padding: 6px;
}

#entry:selected {
  background-color: --wofi-color3;
  color: --wofi-color0;
}

#unselected {
}

#selected {
}

#input,
#entry:selected {
  border-radius: 10px;
}
`;

const wofi: Config = {
  enabled: () => $.commandExists("wofi"),

  files: () => {
    const dir = path.join(CONFIG_DIR, "wofi");
    return [
      new Text([dir, "style.css"], css),
      new Ini(
        [dir, "config"],
        {
          show: "drun",
          prompt: "",
          normal_window: false,
          layer: "top",
          term: "alacritty",

          // Geometry
          width: "450px",
          height: "370px",
          location: 0,
          orientation: "vertical",
          halign: "fill",
          line_wrap: "off",
          dynamic_lines: false,

          // Images
          allow_markup: true,
          allow_images: true,
          image_size: 24,

          // Search
          exec_search: false,
          hide_search: false,
          parse_search: false,
          insensitive: true,

          // Other
          hide_scroll: true,
          no_actions: true,
          sort_order: "default",
          gtk_dark: true,
          filter_rate: 100,

          // Keys
          key_expand: "Tab",
          key_exit: "Escape",
        },
      ),
    ];
  },
};

export default wofi;
