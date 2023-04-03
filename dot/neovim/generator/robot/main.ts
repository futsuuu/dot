import * as Color from "./color.ts";

type Color = Color.Color | "NONE";
const color = Color.color;

const _ = undefined;

let vimFile = `hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "robot"
`;

type Attr =
  | "bold"
  | "underline"
  | "undercurl"
  | "strikethrough"
  | "italic"
  | "NONE";

/**
 * if value == string: link
 * else: set highlight [fg, bg, attribute, sp]
 */
type ColorSchemeVal =
  | string
  | [Color | undefined, Color | undefined, Attr?, Color?];

type ColorScheme = {
  [hlName: string]: ColorScheme | ColorSchemeVal;
};

type FlatColorScheme = {
  [hlName: string]: ColorSchemeVal;
};

/**
 * flatten nested `ColorScheme` like `{ a: { b: "Normal" } } -> { ab: "Normal" }`
 */
function flatColorScheme(cs: ColorScheme): FlatColorScheme {
  const r: { [hlName: string]: ColorSchemeVal } = {};

  function _flat(_cs: ColorScheme, hlName: string[]) {
    Object.entries(_cs).forEach(([key, value]) => {
      hlName.push(key);

      let name = "{}";
      for (const n of hlName) {
        if (name.indexOf("{}") === -1) {
          name += n;
        } else {
          name = name.replace("{}", n);
        }
      }
      if (!Array.isArray(value)) {
        if (typeof value !== "string") {
          // value != ColorSchemeVal
          _flat(value, hlName);
        } else {
          r[name] = value;
        }
      } else {
        r[name] = [...value];
      }

      hlName.pop();
    });
  }

  _flat(cs, []);
  return r;
}

function map(
  cs: ColorScheme | FlatColorScheme,
  func: (
    hlName: string,
    csValue: ColorSchemeVal | ColorScheme
  ) => ColorScheme | undefined
): ColorScheme {
  const new_cs: ColorScheme = {};
  Object.entries(cs).forEach(([hlName, csValue]) => {
    const funcResult = func(hlName, csValue);
    if (funcResult) {
      Object.entries(flatColorScheme(funcResult)).forEach(([key, value]) => {
        new_cs[key] = value;
      });
    }
  });
  return new_cs;
}

function readData(cs: ColorScheme) {
  function addHl(
    hlName: string,
    fg?: Color,
    bg?: Color,
    attr?: Attr,
    sp?: Color,
    link?: string
  ) {
    if (link) {
      vimFile += "hi! link " + hlName + " " + link + "\n";
      return;
    }
    if (attr) {
      vimFile += "hi! ";
    } else {
      vimFile += "hi ";
    }
    vimFile += hlName;
    if (fg) vimFile += " guifg=" + color(fg).string;
    if (bg) vimFile += " guibg=" + color(bg).string;
    if (attr) vimFile += " gui=" + attr;
    if (sp) vimFile += " guisp=" + color(sp).string;

    vimFile += "\n";
  }

  Object.entries(flatColorScheme(cs)).forEach(([key, value]) => {
    if (typeof value === "string") {
      addHl(key, _, _, _, _, value);
    } else {
      addHl(key, ...value, _);
    }
  });
}

////////////////////////////////////////////////////

const isLight = false;
vimFile += isLight ? "set bg=light\n" : "set bg=dark\n";

const bg = color(isLight ? "#fafbfd" : "#171b30");
const fg = isLight ? color(bg).l(43) : color(bg).l(69).s(30);
const red = color(fg).s(75).h(4);
const yellow = color(red).h(53);
const green = color(red).h(123);
const cyan = color(red).h(188);
const blue = color(red).h(253);
const magenta = color(red).h(291);

const diffAdd = green.mix(bg, 0.5).s(80);
const diffChange = blue.mix(bg, 0.5).s(80);
const diffDelete = red.mix(bg, 0.5).s(80);

const select = color(blue).s(100).mix(bg, 0.7);

const diagnostics: ColorScheme = {
  Ok: [fg, _],
  Hint: [green, _],
  Info: [cyan, _],
  Warn: [yellow, _],
  Error: [red, _],
};

const diff: FlatColorScheme = {
  Add: [_, bg.mix(diffAdd, 0.3)],
  Change: [_, bg.mix(diffChange, 0.3)],
  Delete: ["NONE", bg.mix(diffDelete, 0.3), "NONE"],
};

const kinds: FlatColorScheme = {
  Enum: "@lsp.type.enum",
  //File
  //Text
  //Unit
  Class: "@lsp.type.class",
  //Color
  //Event
  //Field
  //Value
  Folder: "Directory",
  Method: "@lsp.type.method",
  //Module
  Struct: "@lsp.type.struct",
  //Default
  Keyword: "Keyword",
  //Snippet
  Constant: "Constant",
  Function: "Function",
  Operator: "Operator",
  //Property
  //Variable
  //Interface
  //Reference
  EnumMember: "@lsp.type.enumMember",
  Constructor: "@constructor",
};

const hlData: ColorScheme = {
  Normal: [fg, bg],
  Cursor: {
    "": [bg, fg],
    IM: "CursorLine",
  },
  CursorLine: [_, bg.mix(fg, isLight ? 0.04 : 0.1)],
  "{}LineNr": {
    "": [bg.mix(fg, 0.23), _],
    Cursor: [bg.mix(fg, 0.55), _, "NONE"],
  },
  Folded: [fg, bg.mix(blue, 0.2)],
  FoldColumn: [bg.mix(fg, 0.5), bg],
  // CursorLineFold: [bg.mix(fg, 0.5), bg],
  SignColumn: [fg, bg],
  Constant: [color(red).s(57).h(33), _],
  Boolean: "Constant",
  Number: "Constant",
  String: [green, _],
  Character: "String",
  Function: [blue, _],
  Float: "Number",
  Type: [cyan, _, "NONE"],
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
  Diff: diff,
  DiffText: [_, bg.mix(diffChange, 0.5)],
  FloatBorder: [bg.mix(fg, 0.4), bg.mix(fg, 0.02)],
  VertSplit: [bg.mix(fg, 0.4), _],
  Underlined: [fg, _, "underline"],
  Bold: [_, _, "bold"],
  Todo: [_, yellow, "bold"],
  Directory: [blue, _],
  WinBar: [bg.mix(fg, 0.8), bg, "NONE"],
  Diagnostic: {
    "": diagnostics,
    Sign: diagnostics,
    Underline: map(diagnostics, (hl_name, cs_value) => {
      const r: ColorScheme = {};
      if (Array.isArray(cs_value)) {
        r[hl_name] = [
          _,
          _,
          hl_name == "Ok" ? "underline" : "undercurl",
          cs_value[0],
        ];
      }
      return r;
    }),
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
    4: [color(green).l(38).mix(cyan, 0.7), _],
    5: [cyan, _],
    6: [blue, _],
    7: [magenta, _],
  },
  Telescope: {
    Normal: "Pmenu",
    Border: "FloatBorder",
  },
  GitSigns: {
    Add: [diffAdd, _],
    Change: [diffChange, _],
    Delete: [diffDelete, _],
  },
  IndentBlankline: {
    Char: [bg.mix(fg, 0.2), _],
  },
  ScrollView: "Visual",
  CmpItem: {
    Abbr: [fg, _],
    Menu: [fg, _],
    Kind: kinds,
  },
  Navic: {
    Icons: kinds,
  },
  NeoTree: {
    Normal: {
      "": [_, bg.mix(fg, 0.03)],
      NC: "NeoTreeNormal",
    },
    Git: {
      Untracked: [color(diffAdd).l(60), _],
    },
    CursorLine: [_, bg.mix(fg, 0.09)],
    WinSeparator: [bg, bg],
  },
};

readData(hlData);

////////////////////////////////////////////////////

const colorsDir = new URL("../../colors/", import.meta.url);
const fileInfo = await Deno.stat(colorsDir);
if (!fileInfo.isDirectory) {
  Deno.mkdir(colorsDir);
}
Deno.writeTextFile(new URL("robot.vim", colorsDir), vimFile);
