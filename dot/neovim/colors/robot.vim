hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "robot"
set bg=dark
hi Normal guifg=#abafc9 guibg=#171b30
hi Cursor guifg=#171b30 guibg=#abafc9
hi CursorLine guibg=#262a3f
hi! CursorLineNr guifg=#63749e gui=bold
hi CursorLineNrBorder guifg=#171b30 guibg=#3a3e54
hi! link CursorColumn CursorLine
hi! link CursorIM CursorLine
hi LineNr guifg=#393d53
hi! MatchParen guibg=#43475e gui=bold
hi Folded guifg=#abafc9 guibg=#303955
hi FoldColumn guifg=#61657c guibg=#171b30
hi SignColumn guifg=#abafc9 guibg=#171b30
hi Constant guifg=#ed9e74
hi! link Boolean Constant
hi! link Number Constant
hi String guifg=#73c35f
hi! link Character String
hi Function guifg=#96b0e8
hi! link Float Number
hi! Type guifg=#66bfbb gui=NONE
hi! Keyword guifg=#cd9fe8 gui=italic
hi Operator guifg=#96b0e8
hi! link Conditional Keyword
hi! link Exception Keyword
hi! link Repeat Keyword
hi! link Include Keyword
hi! link Identifier Type
hi! link Label Identifier
hi! link Statement Keyword
hi PreProc guifg=#cd9fe8
hi! Title guifg=#96b0e8 gui=bold
hi! link Special Keyword
hi SpecialKey guifg=#96b0e8
hi SpecialChar guifg=#cd9fe8
hi NonText guifg=#35394f
hi Conceal guifg=#7f839b guibg=NONE
hi Delimiter guifg=#96b0e8
hi! Comment guifg=#61657c gui=italic
hi Visual guibg=#38486e
hi Search guifg=NONE guibg=#4b5d86
hi! link IncSearch Search
hi Pmenu guibg=#1d2136
hi PmenuSel guibg=#303955
hi PmenuThumb guifg=#63749e guibg=#171b30
hi PmenuSbar guibg=#35394f
hi DiffAdd guibg=#1d3630
hi DiffChange guibg=#203158
hi! DiffDelete guifg=NONE guibg=#462145 gui=NONE
hi diffAdded guibg=#1d3630
hi diffChanged guibg=#203158
hi! diffRemoved guifg=NONE guibg=#462145 gui=NONE
hi DiffText guibg=#264072
hi FloatBorder guifg=#52566d guibg=#1a1e33
hi! VertSplit guifg=#61657c guibg=#171b30 gui=NONE
hi! Underlined guifg=#abafc9 gui=underline
hi! Bold gui=bold
hi! Todo guifg=#171b30 guibg=#d9a860 gui=bold
hi Directory guifg=#96b0e8
hi! StatusLine guifg=#61657c guibg=#171b30 gui=NONE
hi! StatusLineNC guifg=#3c4056 guibg=#171b30 gui=NONE
hi! WinBar guifg=#8d91aa guibg=#171b30 gui=NONE
hi DiagnosticOk guifg=#abafc9
hi DiagnosticHint guifg=#73c35f
hi DiagnosticInfo guifg=#66bfbb
hi DiagnosticWarn guifg=#d9a860
hi DiagnosticError guifg=#eb9aa5
hi DiagnosticSignOk guifg=#abafc9
hi DiagnosticSignHint guifg=#73c35f
hi DiagnosticSignInfo guifg=#66bfbb
hi DiagnosticSignWarn guifg=#d9a860
hi DiagnosticSignError guifg=#eb9aa5
hi! DiagnosticUnderlineOk gui=underline guisp=#abafc9
hi! DiagnosticUnderlineHint gui=undercurl guisp=#73c35f
hi! DiagnosticUnderlineInfo gui=undercurl guisp=#66bfbb
hi! DiagnosticUnderlineWarn gui=undercurl guisp=#d9a860
hi! DiagnosticUnderlineError gui=undercurl guisp=#eb9aa5
hi! link Error DiagnosticError
hi! link ErrorMsg Error
hi! @none gui=NONE
hi @variable guifg=#abafc9
hi @variable.builtin guifg=#eb9aa5
hi @parameter guifg=#d9a860
hi! link @boolean Boolean
hi! link @constant Constant
hi! link @number Number
hi! link @float Float
hi! link @string String
hi! link @function Function
hi! link @function.builtin @function
hi! link @function.macro @function
hi! link @comment Comment
hi! link @constructor Function
hi! @property guifg=#abafc9 gui=NONE
hi! link @label Label
hi! link @exception Exception
hi! link @field @property
hi! link @repeat Repeat
hi @punctuation.bracket guifg=#cd9fe8
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
hi htmlTagName guifg=#cd9fe8
hi! link cssTagName htmlTagName
hi LspInlayHint guifg=#686c84 guibg=#1d2136
hi! link LspInfoBorder FloatBorder
hi rainbowcol1 guifg=#eb9aa5
hi rainbowcol2 guifg=#d9a860
hi rainbowcol3 guifg=#73c35f
hi rainbowcol4 guifg=#58a391
hi rainbowcol5 guifg=#66bfbb
hi rainbowcol6 guifg=#96b0e8
hi rainbowcol7 guifg=#cd9fe8
hi! link TelescopeNormal Pmenu
hi! link TelescopeBorder FloatBorder
hi! link TelescopeMatching Search
hi! link TelescopePromptCounter TelescopeBorder
hi GitSignsAdd guifg=#2a7431
hi GitSignsChange guifg=#3665b4
hi GitSignsDelete guifg=#b52f75
hi GitSignsCurrentLineBlame guifg=#5e6d93
hi IndentBlanklineChar guifg=#35394f
hi! link ScrollView Visual
hi CmpItemAbbr guifg=#9ca0ba
hi CmpItemAbbrMatch guifg=#8cb3df
hi CmpItemMenu guifg=#abafc9
hi! link CmpItemKindEnum @lsp.type.enum
hi CmpItemKindText guifg=#868aa3
hi CmpItemKindClass guifg=#d9a860
hi CmpItemKindEvent guifg=#eb9aa5
hi! link CmpItemKindField @lsp.type.enum
hi! link CmpItemKindFolder Directory
hi! link CmpItemKindMethod @lsp.type.method
hi! link CmpItemKindStruct @lsp.type.struct
hi CmpItemKindKeyword guifg=#66bfbb
hi! link CmpItemKindConstant Constant
hi! link CmpItemKindFunction Function
hi! link CmpItemKindOperator Operator
hi! link CmpItemKindProperty @lsp.type.enum
hi CmpItemKindVariable guifg=#cd9fe8
hi! link CmpItemKindEnumMember @lsp.type.enumMember
hi! link CmpItemKindConstructor @constructor
hi! link NavicIconsEnum @lsp.type.enum
hi NavicIconsText guifg=#868aa3
hi NavicIconsClass guifg=#d9a860
hi NavicIconsEvent guifg=#eb9aa5
hi! link NavicIconsField @lsp.type.enum
hi! link NavicIconsFolder Directory
hi! link NavicIconsMethod @lsp.type.method
hi! link NavicIconsStruct @lsp.type.struct
hi NavicIconsKeyword guifg=#66bfbb
hi! link NavicIconsConstant Constant
hi! link NavicIconsFunction Function
hi! link NavicIconsOperator Operator
hi! link NavicIconsProperty @lsp.type.enum
hi NavicIconsVariable guifg=#cd9fe8
hi! link NavicIconsEnumMember @lsp.type.enumMember
hi! link NavicIconsConstructor @constructor
hi FidgetTask guifg=#70748c
hi! link FidgetTitle Title
hi NeoTreeNormal guibg=#1b1f35
hi! link NeoTreeNormalNC NeoTreeNormal
hi NeoTreeDirectoryName guifg=#abafc9
hi NeoTreeDirectoryIcon guifg=#9ca0ba
hi NeoTreeFileIcon guifg=#96b0e8
hi NeoTreeTabActive guifg=#96b0e8 guibg=#1b1f35
hi NeoTreeTabInactive guifg=#4a577a guibg=#1b1f35
hi NeoTreeTabSeparatorActive guifg=#1b1f35
hi NeoTreeTabSeparatorInactive guifg=#1b1f35
hi NeoTreeGitUntracked guifg=#3fa448
hi NeoTreeGitIgnored guifg=#70748c
hi NeoTreeCursorLine guibg=#242a42
hi! link NeoTreeWinSeparator StatusLineNC
hi NeoTreeDimText guifg=#43475e
hi NeoTreeIndentMarker guifg=#3c4056
hi SatelliteBar guibg=#63749e
hi SatelliteCursor guifg=#abafc9
hi! link BufferLineOffsetSeparator NeoTreeWinSeparator
hi BufferLineModified guifg=#eb9aa5
hi! link BufferLineModifiedVisible BufferLineModified
hi! link BufferLineModifiedSelected BufferLineModified
hi BufferLineCloseButtonSelected guifg=#eb9aa5
hi BufferLineIndicatorVisible guifg=#ab7482
hi! link BufferLineIndicatorSelected BufferLineIndicatorVisible
hi! link BufferLineTab BufferLineFill
hi! BufferLineTabSelected guifg=#eb9aa5 guibg=#35394f gui=bold
hi BufferLineTabSeparatorSelected guifg=#35394f guibg=#35394f
hi DapBreakpoint guifg=#eb9aa5
hi DapStopped guifg=#d9a860
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
