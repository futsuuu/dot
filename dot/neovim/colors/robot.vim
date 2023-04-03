hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "robot"
set bg=dark
hi Normal guifg=#a3a7c4 guibg=#171b30
hi Cursor guifg=#171b30 guibg=#a3a7c4
hi! link CursorIM CursorLine
hi CursorLine guibg=#25293f
hi LineNr guifg=#373b52
hi! CursorLineNr guifg=#646881 gui=NONE
hi Folded guifg=#a3a7c4 guibg=#2e3755
hi FoldColumn guifg=#5d617a guibg=#171b30
hi SignColumn guifg=#a3a7c4 guibg=#171b30
hi Constant guifg=#e2976f
hi! link Boolean Constant
hi! link Number Constant
hi String guifg=#69bc54
hi! link Character String
hi Function guifg=#88a9ea
hi! link Float Number
hi! Type guifg=#5ab7b4 gui=NONE
hi Keyword guifg=#cb93e9
hi! link Conditional Keyword
hi! link Exception Keyword
hi! link Repeat Keyword
hi! link Operator Keyword
hi! link Include Keyword
hi! link Label Keyword
hi! link Identifier Keyword
hi! link Statement Keyword
hi PreProc guifg=#cb93e9
hi! Title guifg=#88a9ea gui=bold
hi Special guifg=#cb93e9
hi NonText guifg=#171b30
hi Conceal guifg=#797d98 guibg=NONE
hi Delimiter guifg=#88a9ea
hi! Comment guifg=#5d617a gui=italic
hi Visual guibg=#34466e
hi Pmenu guibg=#1d2136
hi PmenuSel guifg=#171b30 guibg=#77a9ff
hi DiffAdd guibg=#1c342f
hi DiffChange guibg=#203056
hi! DiffDelete guifg=NONE guibg=#452042 gui=NONE
hi DiffText guibg=#253e6f
hi FloatBorder guifg=#4f536b guibg=#1a1e33
hi VertSplit guifg=#4f536b
hi! Underlined guifg=#a3a7c4 gui=underline
hi! Bold gui=bold
hi! Todo guibg=#d2a054 gui=bold
hi Directory guifg=#88a9ea
hi! WinBar guifg=#878ba6 guibg=#171b30 gui=NONE
hi DiagnosticOk guifg=#a3a7c4
hi DiagnosticHint guifg=#69bc54
hi DiagnosticInfo guifg=#5ab7b4
hi DiagnosticWarn guifg=#d2a054
hi DiagnosticError guifg=#ed8d9b
hi DiagnosticSignOk guifg=#a3a7c4
hi DiagnosticSignHint guifg=#69bc54
hi DiagnosticSignInfo guifg=#5ab7b4
hi DiagnosticSignWarn guifg=#d2a054
hi DiagnosticSignError guifg=#ed8d9b
hi! DiagnosticUnderlineOk gui=underline guisp=#a3a7c4
hi! DiagnosticUnderlineHint gui=undercurl guisp=#69bc54
hi! DiagnosticUnderlineInfo gui=undercurl guisp=#5ab7b4
hi! DiagnosticUnderlineWarn gui=undercurl guisp=#d2a054
hi! DiagnosticUnderlineError gui=undercurl guisp=#ed8d9b
hi! @none gui=NONE
hi @variable guifg=#a3a7c4
hi @variable.builtin guifg=#ed8d9b
hi @parameter guifg=#d2a054
hi! link @boolean Boolean
hi! link @constant Constant
hi! link @number Number
hi! link @float Float
hi! link @string String
hi! link @comment Comment
hi! link @constructor Special
hi! @property guifg=#a3a7c4 gui=NONE
hi! link @label Label
hi! link @exception Exception
hi! link @field @property
hi! link @repeat Repeat
hi @punctuation.bracket guifg=#cb93e9
hi! link @punctuation.delimiter Delimiter
hi! link @keyword Keyword
hi! link @keyword.return @keyword
hi! link @keyword.coroutine @keyword
hi! link @text @none
hi! link @text.underline Underlined
hi! link @lsp.type.keyword @keyword
hi! link @lsp.type.variable @variable
hi! link @lsp.type.parameter @parameter
hi! link @lsp.type.property @property
hi! link @lsp.typemod.variable.defaultLibrary @variable.builtin
hi! link @tagattribute @property
hi rainbowcol1 guifg=#ed8d9b
hi rainbowcol2 guifg=#d2a054
hi rainbowcol3 guifg=#69bc54
hi rainbowcol4 guifg=#4f9e8a
hi rainbowcol5 guifg=#5ab7b4
hi rainbowcol6 guifg=#88a9ea
hi rainbowcol7 guifg=#cb93e9
hi! link TelescopeNormal Pmenu
hi! link TelescopeBorder FloatBorder
hi GitSignsAdd guifg=#286f2c
hi GitSignsChange guifg=#3361ad
hi GitSignsDelete guifg=#af2d6c
hi IndentBlanklineChar guifg=#33374e
hi! link ScrollView Visual
hi CmpItemAbbr guifg=#a3a7c4
hi CmpItemMenu guifg=#a3a7c4
hi! link CmpItemKindEnum @lsp.type.enum
hi! link CmpItemKindClass @lsp.type.class
hi! link CmpItemKindFolder Directory
hi! link CmpItemKindMethod @lsp.type.method
hi! link CmpItemKindStruct @lsp.type.struct
hi! link CmpItemKindKeyword Keyword
hi! link CmpItemKindConstant Constant
hi! link CmpItemKindFunction Function
hi! link CmpItemKindOperator Operator
hi! link CmpItemKindEnumMember @lsp.type.enumMember
hi! link CmpItemKindConstructor @constructor
hi! link NavicIconsEnum @lsp.type.enum
hi! link NavicIconsClass @lsp.type.class
hi! link NavicIconsFolder Directory
hi! link NavicIconsMethod @lsp.type.method
hi! link NavicIconsStruct @lsp.type.struct
hi! link NavicIconsKeyword Keyword
hi! link NavicIconsConstant Constant
hi! link NavicIconsFunction Function
hi! link NavicIconsOperator Operator
hi! link NavicIconsEnumMember @lsp.type.enumMember
hi! link NavicIconsConstructor @constructor
hi NeoTreeNormal guibg=#1b1f34
hi! link NeoTreeNormalNC NeoTreeNormal
hi NeoTreeGitUntracked guifg=#3fa445
hi NeoTreeCursorLine guibg=#24283d
hi NeoTreeWinSeparator guifg=#171b30 guibg=#171b30
