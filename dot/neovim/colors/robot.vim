hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "robot"
set bg=light
hi Normal guifg=#4d678b guibg=#fafbfd
hi Cursor guifg=#fafbfd guibg=#4d678b
hi! link CursorIM CursorLine
hi CursorLine guibg=#f3f5f8
hi LineNr guifg=#d2d9e3
hi! CursorLineNr guifg=#9baabe gui=NONE
hi Folded guifg=#4d678b guibg=#d4ddec
hi FoldColumn guifg=#a3b1c4 guibg=#fafbfd
hi SignColumn guifg=#4d678b guibg=#fafbfd
hi Constant guifg=#8b5a41
hi! link Boolean Constant
hi! link Number Constant
hi String guifg=#3d722f
hi! link Character String
hi Function guifg=#3a66a8
hi! link Float Number
hi! Type guifg=#336f6d gui=NONE
hi Keyword guifg=#953db8
hi! link Conditional Keyword
hi! link Exception Keyword
hi! link Repeat Keyword
hi! link Operator Keyword
hi! link Include Keyword
hi! link Label Keyword
hi! link Identifier Keyword
hi! link Statement Keyword
hi PreProc guifg=#953db8
hi! Title guifg=#3a66a8 gui=bold
hi Special guifg=#953db8
hi NonText guifg=#fafbfd
hi Conceal guifg=#8193ad guibg=NONE
hi Delimiter guifg=#3a66a8
hi! Comment guifg=#a3b1c4 gui=italic
hi Visual guibg=#afceea
hi Pmenu guibg=#f3f5f8
hi PmenuSel guifg=#fafbfd guibg=#0066be
hi DiffAdd guibg=#ceeac8
hi DiffChange guibg=#d6e5f9
hi! DiffDelete guifg=NONE guibg=#f7d9e2 gui=NONE
hi DiffText guibg=#bed6f6
hi FloatBorder guifg=#b5c0cf guibg=#f7f8fb
hi VertSplit guifg=#b5c0cf
hi! Underlined guifg=#4d678b gui=underline
hi! Bold gui=bold
hi! Todo guibg=#806030 gui=bold
hi Directory guifg=#3a66a8
hi! WinBar guifg=#7085a2 guibg=#fafbfd gui=NONE
hi DiagnosticOk guifg=#4d678b
hi DiagnosticHint guifg=#3d722f
hi DiagnosticInfo guifg=#336f6d
hi DiagnosticWarn guifg=#806030
hi DiagnosticError guifg=#b93250
hi DiagnosticSignOk guifg=#4d678b
hi DiagnosticSignHint guifg=#3d722f
hi DiagnosticSignInfo guifg=#336f6d
hi DiagnosticSignWarn guifg=#806030
hi DiagnosticSignError guifg=#b93250
hi! DiagnosticUnderlineOk gui=underline guisp=#4d678b
hi! DiagnosticUnderlineHint gui=undercurl guisp=#3d722f
hi! DiagnosticUnderlineInfo gui=undercurl guisp=#336f6d
hi! DiagnosticUnderlineWarn gui=undercurl guisp=#806030
hi! DiagnosticUnderlineError gui=undercurl guisp=#b93250
hi! @none gui=NONE
hi @variable guifg=#4d678b
hi @variable.builtin guifg=#b93250
hi @parameter guifg=#806030
hi! link @boolean Boolean
hi! link @constant Constant
hi! link @number Number
hi! link @float Float
hi! link @string String
hi! link @comment Comment
hi! link @constructor Special
hi! @property guifg=#4d678b gui=NONE
hi! link @label Label
hi! link @exception Exception
hi! link @field @property
hi! link @repeat Repeat
hi @punctuation.bracket guifg=#953db8
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
hi rainbowcol1 guifg=#b93250
hi rainbowcol2 guifg=#806030
hi rainbowcol3 guifg=#3d722f
hi rainbowcol4 guifg=#346c58
hi rainbowcol5 guifg=#336f6d
hi rainbowcol6 guifg=#3a66a8
hi rainbowcol7 guifg=#953db8
hi! link TelescopeNormal Pmenu
hi! link TelescopeBorder FloatBorder
hi GitSignsAdd guifg=#69c34d
hi GitSignsChange guifg=#82b1f0
hi GitSignsDelete guifg=#f18aa4
hi IndentBlanklineChar guifg=#d7dde6
hi! link ScrollView Visual
hi CmpItemAbbr guifg=#4d678b
hi CmpItemMenu guifg=#4d678b
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
hi NeoTreeNormal guibg=#f5f7fa
hi! link NeoTreeNormalNC NeoTreeNormal
hi NeoTreeGitUntracked guifg=#56a23f
hi NeoTreeCursorLine guibg=#eaeef3
hi NeoTreeWinSeparator guifg=#fafbfd guibg=#fafbfd
hi! FoldLevel1 guifg=#b5c0cf guibg=#eaeef3 gui=bold
hi! FoldLevel2 guifg=#b5c0cf guibg=#dee3eb gui=bold
hi! FoldLevel3 guifg=#a3b1c4 guibg=#d2d9e3 gui=bold
hi! FoldLevel4 guifg=#a3b1c4 guibg=#c6cfdb gui=bold
hi! FoldLevel5 guifg=#92a2b9 guibg=#bac4d3 gui=bold
hi! FoldLevel6 guifg=#92a2b9 guibg=#aebacb gui=bold
hi! FoldLevel7 guifg=#8193ad guibg=#a2b0c3 gui=bold
hi! FoldLevel8 guifg=#7085a2 guibg=#96a5bb gui=bold
hi! FoldLevel9 guifg=#7085a2 guibg=#8a9bb3 gui=bold
hi! FoldLevel10 guifg=#5e7696 guibg=#7d90ab gui=bold
