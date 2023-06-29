hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "robot"
set bg=dark
hi Normal guifg=#abafc9 guibg=#171b30
hi Cursor guifg=#171b30 guibg=#abafc9
hi CursorLine guibg=#262a3f
hi! link CursorColumn CursorLine
hi! link CursorIM CursorLine
hi LineNr guifg=#393d53
hi! CursorLineNr guifg=#686c84 gui=NONE
hi! MatchParen guibg=#43475e gui=bold
hi Folded guifg=#abafc9 guibg=#303956
hi FoldColumn guifg=#61657c guibg=#171b30
hi SignColumn guifg=#abafc9 guibg=#171b30
hi Constant guifg=#e4a181
hi! link Boolean Constant
hi! link Number Constant
hi String guifg=#6cc456
hi! link Character String
hi Function guifg=#94b0ec
hi! link Float Number
hi! Type guifg=#5cc0bc gui=NONE
hi Keyword guifg=#d09dec
hi! link Conditional Keyword
hi! link Exception Keyword
hi! link Repeat Keyword
hi! link Operator Keyword
hi! link Include Keyword
hi! link Label Keyword
hi! link Identifier Keyword
hi! link Statement Keyword
hi PreProc guifg=#d09dec
hi! Title guifg=#94b0ec gui=bold
hi Special guifg=#d09dec
hi! link SpecialKey Special
hi NonText guifg=#35394f
hi Conceal guifg=#7f839b guibg=NONE
hi Delimiter guifg=#94b0ec
hi! Comment guifg=#61657c gui=italic
hi Visual guibg=#39486e
hi Search guifg=NONE guibg=#4b5d87
hi! link IncSearch Search
hi Pmenu guibg=#1d2136
hi PmenuSel guibg=#303956
hi PmenuThumb guifg=#55668e guibg=#171b30
hi PmenuSbar guibg=#35394f
hi DiffAdd guibg=#1d362f
hi DiffChange guibg=#203157
hi! DiffDelete guifg=NONE guibg=#472144 gui=NONE
hi DiffText guibg=#264071
hi FloatBorder guifg=#52566d guibg=#1a1e33
hi! VertSplit guifg=#61657c guibg=#171b30 gui=NONE
hi! Underlined guifg=#abafc9 gui=underline
hi! Bold gui=bold
hi! Todo guifg=#171b30 guibg=#dca757 gui=bold
hi Directory guifg=#94b0ec
hi! StatusLine guifg=#61657c guibg=#171b30 gui=NONE
hi! StatusLineNC guifg=#3c4056 guibg=#171b30 gui=NONE
hi! WinBar guifg=#8d91aa guibg=#171b30 gui=NONE
hi DiagnosticOk guifg=#abafc9
hi DiagnosticHint guifg=#6cc456
hi DiagnosticInfo guifg=#5cc0bc
hi DiagnosticWarn guifg=#dca757
hi DiagnosticError guifg=#ef98a4
hi DiagnosticSignOk guifg=#abafc9
hi DiagnosticSignHint guifg=#6cc456
hi DiagnosticSignInfo guifg=#5cc0bc
hi DiagnosticSignWarn guifg=#dca757
hi DiagnosticSignError guifg=#ef98a4
hi! DiagnosticUnderlineOk gui=underline guisp=#abafc9
hi! DiagnosticUnderlineHint gui=undercurl guisp=#6cc456
hi! DiagnosticUnderlineInfo gui=undercurl guisp=#5cc0bc
hi! DiagnosticUnderlineWarn gui=undercurl guisp=#dca757
hi! DiagnosticUnderlineError gui=undercurl guisp=#ef98a4
hi! link Error DiagnosticError
hi! link ErrorMsg Error
hi! @none gui=NONE
hi @variable guifg=#abafc9
hi @variable.builtin guifg=#ef98a4
hi @parameter guifg=#dca757
hi! link @boolean Boolean
hi! link @constant Constant
hi! link @number Number
hi! link @float Float
hi! link @string String
hi! link @comment Comment
hi! link @constructor Special
hi! @property guifg=#abafc9 gui=NONE
hi! link @label Label
hi! link @exception Exception
hi! link @field @property
hi! link @repeat Repeat
hi @punctuation.bracket guifg=#d09dec
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
hi! link @lsp.typemod.enum.defaultLibrary @variable.builtin
hi! link @lsp.typemod.enumMember.defaultLibrary @variable.builtin
hi! link @tagattribute @property
hi LspInlayHint guifg=#686c84 guibg=#1d2136
hi! link LspInfoBorder FloatBorder
hi rainbowcol1 guifg=#ef98a4
hi rainbowcol2 guifg=#dca757
hi rainbowcol3 guifg=#6cc456
hi rainbowcol4 guifg=#50a490
hi rainbowcol5 guifg=#5cc0bc
hi rainbowcol6 guifg=#94b0ec
hi rainbowcol7 guifg=#d09dec
hi! link TelescopeNormal Pmenu
hi! link TelescopeBorder FloatBorder
hi! link TelescopeMatching Search
hi! link TelescopePromptCounter TelescopeBorder
hi GitSignsAdd guifg=#2a742c
hi GitSignsChange guifg=#3566b2
hi GitSignsDelete guifg=#b52f74
hi IndentBlanklineChar guifg=#35394f
hi! link ScrollView Visual
hi CmpItemAbbr guifg=#abafc9
hi CmpItemMenu guifg=#abafc9
hi! link CmpItemKindEnum @lsp.type.enum
hi CmpItemKindText guifg=#868aa3
hi CmpItemKindClass guifg=#dca757
hi CmpItemKindEvent guifg=#ef98a4
hi! link CmpItemKindField @lsp.type.enum
hi! link CmpItemKindFolder Directory
hi! link CmpItemKindMethod @lsp.type.method
hi! link CmpItemKindStruct @lsp.type.struct
hi CmpItemKindKeyword guifg=#5cc0bc
hi! link CmpItemKindConstant Constant
hi! link CmpItemKindFunction Function
hi! link CmpItemKindOperator Operator
hi! link CmpItemKindProperty @lsp.type.enum
hi! link CmpItemKindVariable Keyword
hi! link CmpItemKindEnumMember @lsp.type.enumMember
hi! link CmpItemKindConstructor @constructor
hi! link NavicIconsEnum @lsp.type.enum
hi NavicIconsText guifg=#868aa3
hi NavicIconsClass guifg=#dca757
hi NavicIconsEvent guifg=#ef98a4
hi! link NavicIconsField @lsp.type.enum
hi! link NavicIconsFolder Directory
hi! link NavicIconsMethod @lsp.type.method
hi! link NavicIconsStruct @lsp.type.struct
hi NavicIconsKeyword guifg=#5cc0bc
hi! link NavicIconsConstant Constant
hi! link NavicIconsFunction Function
hi! link NavicIconsOperator Operator
hi! link NavicIconsProperty @lsp.type.enum
hi! link NavicIconsVariable Keyword
hi! link NavicIconsEnumMember @lsp.type.enumMember
hi! link NavicIconsConstructor @constructor
hi NeoTreeNormal guibg=#1b1f35
hi! link NeoTreeNormalNC NeoTreeNormal
hi NeoTreeDirectoryName guifg=#abafc9
hi NeoTreeDirectoryIcon guifg=#9ca0ba
hi NeoTreeFileIcon guifg=#94b0ec
hi NeoTreeTabActive guifg=#94b0ec guibg=#1b1f35
hi NeoTreeTabInactive guifg=#49577b guibg=#1b1f35
hi NeoTreeTabSeparatorActive guifg=#1b1f35
hi NeoTreeTabSeparatorInactive guifg=#1b1f35
hi NeoTreeGitUntracked guifg=#3fa442
hi NeoTreeCursorLine guibg=#232a43
hi! link NeoTreeWinSeparator StatusLineNC
hi NeoTreeDimText guifg=#43475e
hi NeoTreeIndentMarker guifg=#3c4056
hi! link BufferLineOffsetSeparator NeoTreeWinSeparator
hi BufferLineModified guifg=#ef98a4
hi! link BufferLineModifiedVisible BufferLineModified
hi! link BufferLineModifiedSelected BufferLineModified
hi BufferLineIndicatorVisible guifg=#ae7381
hi! link BufferLineIndicatorSelected BufferlineIndicatorVisible
hi FoldLevel1 guifg=#171b30 guibg=#24283e
hi FoldLevel2 guifg=#24283e guibg=#32364c
hi FoldLevel3 guifg=#32364c guibg=#3f4359
hi FoldLevel4 guifg=#3f4359 guibg=#4c5067
hi FoldLevel5 guifg=#4c5067 guibg=#5a5e75
hi FoldLevel6 guifg=#5a5e75 guibg=#676b83
hi FoldLevel7 guifg=#676b83 guibg=#747890
hi FoldLevel8 guifg=#747890 guibg=#82869e
hi FoldLevel9 guifg=#82869e guibg=#8f93ac
hi FoldLevel10 guifg=#8f93ac guibg=#9ca0ba
hi FoldLevel11 guifg=#9ca0ba guibg=#aaaec7
