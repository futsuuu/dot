import { Color, color } from "./color.ts";

let vim_file = `hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "robot"
set bg=light
`;

type Attr =
  | "bold"
  | "underline"
  | "undercurl"
  | "strikethrough"
  | "italic"
  | "NONE";

type ColorScheme = {
  [hl_name: string]:
    | string
    | [Color | "NONE" | null, Color | "NONE" | null, Attr?, Color?]
    | ColorScheme;
};

function read_data(cs: ColorScheme) {
  function add_hl(
    hl_name: string,
    fg: Color | "NONE" | null,
    bg: Color | "NONE" | null,
    attr?: Attr | null,
    sp?: Color | null,
    link?: string | null,
  ) {
    if (link) {
      vim_file += "hi! link " + hl_name + " " + link + "\n";
      return;
    }
    if (attr) {
      vim_file += "hi! ";
    } else {
      vim_file += "hi ";
    }
    vim_file += hl_name;
    if (fg) {
      vim_file += " guifg=";
      if (fg === "NONE") vim_file += "NONE";
      else vim_file += fg.hex;
    }
    if (bg) {
      vim_file += " guibg=";
      if (bg === "NONE") vim_file += "NONE";
      else vim_file += bg.hex;
    }
    if (attr) {
      vim_file += " gui=" + attr;
    }
    if (sp) {
      vim_file += " guisp=" + sp.hex;
    }
    vim_file += "\n";
  }

  function _read_data(_cs: ColorScheme, hl_name: string[]) {
    Object.entries(_cs).forEach(([key, value]) => {
      hl_name.push(key);

      let name = "{}";
      for (const n of hl_name) {
        if (name.indexOf("{}") === -1) {
          name += n;
        } else {
          name = name.replace("{}", n);
        }
      }

      if (!Array.isArray(value)) {
        if (typeof value !== "string") {
          _read_data(value, hl_name);
        } else {
          add_hl(name, _, _, _, _, value);
        }
      } else {
        add_hl(name, ...value, _);
      }

      hl_name.pop();
    });
  }
  _read_data(cs, []);
}

const _ = null;

////////////////////////////////////////////////////

const bg = color("#fafbfd");
const fg = color(bg).l(38);
const red = color(fg).l(46).s(75).h(0);
const yellow = color(red).h(53);
const green = color(red).h(123);
const cyan = color(red).h(188);
const blue = color(red).h(253);
const magenta = color(red).h(291);

const light_green = color(green).l(38).mix(cyan, 0.7);

const select = color(blue).s(100).mix(bg, 0.7);

const diagnostics: ColorScheme = {
  Ok: [fg, _],
  Hint: [green, _],
  Info: [cyan, _],
  Warn: [yellow, _],
  Error: [red, _],
};

const gitsigns: ColorScheme = {
  Add: [green.mix(bg, 0.6).s(80), _],
  Change: [blue.mix(bg, 0.4).s(80), _],
  Delete: [red.mix(bg, 0.6).s(80), _],
};

const hl_data: ColorScheme = {
  Normal: [fg, bg],
  CursorLine: [_, bg.mix(fg, 0.04)],
  "{}LineNr": {
    "": [bg.mix(fg, 0.23), _],
    Cursor: [bg.mix(fg, 0.55), _, "NONE"],
  },
  SignColumn: [fg, bg],
  Constant: [color(red).s(57).h(33), _],
  Boolean: "Constant",
  Number: "Constant",
  String: [green, _],
  Character: "String",
  Function: [blue, _],
  Float: "Number",
  Type: [light_green, _, "NONE"],
  Keyword: [magenta, _],
  Conditional: "Keyword",
  Exception: "Keyword",
  Repeat: "Keyword",
  Operator: "Keyword",
  Include: "Keyword",
  Label: "Keyword",
  Identifier: "Keyword",
  Statement: "Keyword",
  PreProc: [magenta, _],
  Title: [blue, _, "bold"],
  Special: [magenta, _],
  NonText: [bg, _],
  Conceal: [bg.mix(fg, 0.7), "NONE"],
  Delimiter: [blue, _],
  Comment: [bg.mix(fg, 0.5), _, "italic"],
  Visual: [_, select],
  Pmenu: {
    "": [_, bg.mix(fg, 0.04)],
    Sel: [bg, color(blue).s(100)],
  },
  FloatBorder: [bg.mix(fg, 0.4), bg.mix(fg, 0.02)],
  VertSplit: [bg.mix(fg, 0.1), _],
  Underlined: [fg, _, "underline"],
  Bold: [_, _, "bold"],
  Todo: [_, yellow, "bold"],
  Directory: [blue, _],
  WinBar: [bg.mix(fg, 0.8), bg, "NONE"],
  Diagnostic: {
    "": diagnostics,
    Sign: diagnostics,
    Underline: {
      Ok: [_, _, "underline", fg],
      Hint: [_, _, "undercurl", green],
      Info: [_, _, "undercurl", cyan],
      Warn: [_, _, "undercurl", yellow],
      Error: [_, _, "undercurl", red],
    },
    VirtualText: {},
  },
  "@": {
    none: [_, _, "NONE"],
    variable: {
      "": [fg, _],
      ".builtin": [red, _],
    },
    parameter: [yellow, _],
    boolean: "Boolean",
    constant: "Constant",
    number: "Number",
    float: "Float",
    string: "String",
    comment: "Comment",
    constructor: "Special",
    property: [fg, _, "NONE"],
    label: "Label",
    exception: "Exception",
    field: "@property",
    repeat: "Repeat",
    "punctuation.": {
      bracket: [magenta, _],
      special: {},
      delimiter: "Delimiter",
    },
    keyword: {
      "": "Keyword",
      ".": {
        return: "@keyword",
        coroutine: "@keyword",
      },
    },
    text: {
      "": "@none",
      ".": {
        underline: "Underlined",
      },
    },
    "lsp.type": {
      ".": {
        keyword: "@keyword",
        variable: "@variable",
        parameter: "@parameter",
        property: "@property",
      },
      "mod.": {
        "{}.defaultLibrary": {
          variable: "@variable.builtin",
        },
        "{}.injected": {},
      },
    },
    tag: {
      attribute: "@property",
    },
  },
  rainbowcol: {
    1: [red, _],
    2: [yellow, _],
    3: [green, _],
    4: [light_green, _],
    5: [cyan, _],
    6: [blue, _],
    7: [magenta, _],
  },
  Telescope: {
    Normal: "Pmenu",
    Border: "FloatBorder",
  },
  GitSigns: gitsigns,
  IndentBlankline: {
    Char: [bg.mix(fg, 0.2), _],
  },
  CmpItem: {
    Abbr: [fg, _],
    Menu: [fg, _],
  },
  NeoTree: {
    Normal: {
      "": [_, bg.mix(fg, 0.03)],
      NC: "NeoTreeNormal",
    },
    Git: {
      Untracked: "GitSignsAdd",
    },
    CursorLine: [_, bg.mix(fg, 0.09)],
    WinSeparator: [bg, bg],
  },
};

read_data(hl_data);

////////////////////////////////////////////////////

const colors_dir = new URL("../../colors/", import.meta.url);
const file_info = await Deno.stat(colors_dir);
if (!file_info.isDirectory) {
  Deno.mkdir(colors_dir);
}
Deno.writeTextFile(new URL("robot.vim", colors_dir), vim_file);
