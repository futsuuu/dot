hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "robot"
set bg=light
hi Normal guifg=#435b7b guibg=#fafbfd
hi CursorLine guibg=#f3f5f8
hi LineNr guifg=#d0d6df
hi! CursorLineNr guifg=#95a3b5 gui=NONE
hi SignColumn guifg=#435b7b guibg=#fafbfd
hi Constant guifg=#946146
hi! link Boolean Constant
hi! link Number Constant
hi String guifg=#427a33
hi! link Character String
hi Function guifg=#3f6db4
hi! link Float Number
hi! Type guifg=#99454f gui=NONE
hi Keyword guifg=#9f42c5
hi! link Conditional Keyword
hi! link Exception Keyword
hi! link Repeat Keyword
hi! link Operator Keyword
hi! link Include Keyword
hi! link Label Keyword
hi! link Identifier Keyword
hi! link Statement Keyword
hi PreProc guifg=#9f42c5
hi! Title guifg=#3f6db4 gui=bold
hi Special guifg=#9f42c5
hi NonText guifg=#fafbfd
hi Conceal guifg=#7a8ba2 guibg=NONE
hi Delimiter guifg=#3f6db4
hi! Comment guifg=#9eabbc gui=italic
hi Visual guibg=#afd0ee
hi Pmenu guibg=#f3f5f8
hi PmenuSel guifg=#fafbfd guibg=#006dcc
hi FloatBorder guifg=#b1bbc9 guibg=#f6f8fa
hi VertSplit guifg=#e8ebf0
hi! Underlined guifg=#435b7b gui=underline
hi! Bold gui=bold
hi! Todo guibg=#896734 gui=bold
hi Directory guifg=#3f6db4
hi! WinBar guifg=#687b95 guibg=#fafbfd gui=NONE
hi DiagnosticOk guifg=#435b7b
hi DiagnosticHint guifg=#427a33
hi DiagnosticInfo guifg=#377775
hi DiagnosticWarn guifg=#896734
hi DiagnosticError guifg=#c43760
hi DiagnosticSignOk guifg=#435b7b
hi DiagnosticSignHint guifg=#427a33
hi DiagnosticSignInfo guifg=#377775
hi DiagnosticSignWarn guifg=#896734
hi DiagnosticSignError guifg=#c43760
hi! DiagnosticUnderlineOk gui=underline guisp=#435b7b
hi! DiagnosticUnderlineHint gui=undercurl guisp=#427a33
hi! DiagnosticUnderlineInfo gui=undercurl guisp=#377775
hi! DiagnosticUnderlineWarn gui=undercurl guisp=#896734
hi! DiagnosticUnderlineError gui=undercurl guisp=#c43760
hi! @none gui=NONE
hi @variable guifg=#435b7b
hi @variable.builtin guifg=#c43760
hi @parameter guifg=#896734
hi! link @boolean Boolean
hi! link @constant Constant
hi! link @number Number
hi! link @float Float
hi! link @string String
hi! link @comment Comment
hi! link @constructor Special
hi! @property guifg=#435b7b gui=NONE
hi! link @label Label
hi! link @exception Exception
hi! link @field @property
hi! link @repeat Repeat
hi @punctuation.bracket guifg=#9f42c5
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
hi rainbowcol1 guifg=#c43760
hi rainbowcol2 guifg=#896734
hi rainbowcol3 guifg=#427a33
hi rainbowcol4 guifg=#99454f
hi rainbowcol5 guifg=#377775
hi rainbowcol6 guifg=#3f6db4
hi rainbowcol7 guifg=#9f42c5
hi! link TelescopeNormal Pmenu
hi! link TelescopeBorder FloatBorder
hi GitSignsAdd guifg=#73d755
hi GitSignsChange guifg=#6fa7ed
hi GitSignsDelete guifg=#f3a6bf
hi IndentBlanklineChar guifg=#d5dbe3
hi CmpItemAbbr guifg=#435b7b
hi CmpItemMenu guifg=#435b7b
hi NeoTreeNormal guibg=#f5f6f9
hi! link NeoTreeNormalNC NeoTreeNormal
hi! link NeoTreeGitUntracked GitSignsAdd
hi NeoTreeCursorLine guibg=#eaedf1
hi NeoTreeWinSeparator guifg=#fafbfd guibg=#fafbfd
