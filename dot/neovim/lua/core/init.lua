local o, opt, optl = vim.o, vim.opt, vim.opt_local

local au = vim.api.nvim_create_autocmd
local m = vim.keymap.set

local utils = require 'utils'

opt.syntax = 'off'

opt.title = true
au({ 'BufWinEnter', 'DirChanged' }, {
  pattern = '*',
  callback = function()
    local homedir = vim.uv.os_homedir() or '////'
    o.titlestring = 'Neovim ❯ ' .. vim.fn.getcwd():gsub(homedir, '~'):gsub('\\', '/')
  end,
})

opt.cmdheight = 0
opt.laststatus = 0
opt.termguicolors = true
opt.fillchars:append {
  eob = ' ',
  diff = '╱',
  stl = '─',
  stlnc = '─',
}
opt.statusline = "%{''}"
opt.tabline = "%{''}"
opt.inccommand = 'split'
opt.splitright = true
opt.splitbelow = true

require 'core.restore_dir'

m('n', '<Space>', '<Nop>')
m('n', '<Space><CR>', function()
  local shell, shellcmdflag, shellxquote = o.shell, o.shellcmdflag, o.shellxquote
  o.shell = 'nu'
  o.shellcmdflag = '-c'
  o.shellxquote = ''
  vim.cmd.terminal()
  o.shell = shell
  o.shellcmdflag = shellcmdflag
  o.shellxquote = shellxquote
end)

au('InsertEnter', {
  pattern = '*',
  once = true,
  callback = function()
    opt.showmode = false
    opt.completeopt = { 'menu', 'menuone', 'noinsert' }
    m('i', 'jj', '<Esc>')
  end,
})

au('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
})

au('WinNew', {
  pattern = '*',
  once = true,
  callback = function()
    m('n', '<C-h>', '<C-w>h')
    m('n', '<C-j>', '<C-w>j')
    m('n', '<C-k>', '<C-w>k')
    m('n', '<C-l>', '<C-w>l')
  end,
})

au('CursorMoved', {
  pattern = '*',
  once = true,
  callback = function()
    opt.cursorline = true
    opt.scrolloff = 10
    opt.sidescroll = 1
    opt.sidescrolloff = 16
    opt.virtualedit = 'onemore'
    opt.wrap = false
    m('n', '<Esc><Esc>', '<Cmd>nohlsearch<CR><Esc>')
    require 'core.cursorline'
  end,
})

au('LspAttach', {
  once = true,
  callback = utils.lazy_require('refcounter').setup,
})

au('BufReadPre', {
  pattern = '*',
  once = true,
  callback = function()
    require 'core.winbar'
  end,
})

au('BufRead', {
  pattern = '*',
  once = true,
  callback = function()
    opt.backup = false
    opt.writebackup = false
    opt.swapfile = false
    opt.syntax = 'on'

    opt.encoding = 'utf-8'
    opt.fileencodings = { 'ucs-bom', 'utf-8', 'iso-2022-jp', 'euc-jp', 'cp932', 'default', 'latin' }
    opt.fileformats = { 'unix', 'dos', 'mac' }

    opt.clipboard = 'unnamedplus'

    opt.hlsearch = true
    opt.incsearch = true
    opt.ignorecase = true
    opt.smartcase = true

    opt.autoread = true
    opt.list = true
    opt.listchars = { trail = '╴', tab = '', extends = '' }
    opt.autochdir = false
    opt.autoindent = true
    opt.smartindent = true
    opt.expandtab = true
    opt.shiftwidth = 2
    opt.tabstop = 2
    opt.softtabstop = 2

    opt.numberwidth = 6
    opt.number = true
    opt.signcolumn = 'yes:2'
    opt.statuscolumn = ' %=%l%r%s '

    local function in_indent(include_head)
      return (vim.fn.col '.' - (include_head and 1 or 0)) <= vim.fn.indent '.'
    end

    m('n', 'a', function()
      return vim.api.nvim_get_current_line():match '^%s*$' and 'S' or 'a'
    end, { expr = true })

    m({ 'n', 'v' }, 'f<Space>', function()
      return in_indent() and '^f<Space>' or 'f<Space>'
    end, { expr = true })
    m({ 'n', 'v' }, 't<Space>', function()
      return in_indent() and '^t<Space>' or 't<Space>'
    end, { expr = true })

    m({ 'n', 'v' }, 'l', function()
      if not in_indent() then
        return 'l'
      end
      local col = vim.fn.col '.' - 1
      local sw = vim.fn.shiftwidth()
      return (sw - col % sw) .. 'l'
    end, { expr = true })
    m({ 'n', 'v' }, 'h', function()
      if not in_indent(true) then
        return 'h'
      end
      local col = vim.fn.col '.' - 1
      local sw = vim.fn.shiftwidth()
      return (sw - col % sw) .. 'h'
    end, { expr = true })

    local function hover()
      local filetype = vim.bo.filetype
      if vim.tbl_contains({ 'vim', 'help' }, filetype) then
        vim.cmd('h ' .. vim.fn.expand '<cword>')
      elseif vim.tbl_contains({ 'man' }, filetype) then
        vim.cmd('Man ' .. vim.fn.expand '<cword>')
      elseif vim.fn.expand '%:t' == 'Cargo.toml' and require('crates').popup_available() then
        require('crates').show_popup()
      else
        vim.lsp.buf.hover()
      end
    end
    m('n', 'K', hover)
    m('n', '<RightMouse>', hover)

    m('n', '<Space>ln', vim.lsp.buf.rename)
    m('n', '<Space>lf', vim.lsp.buf.format)

    local opts = { float = { border = 'none' } }

    m('n', ']d', function()
      vim.diagnostic.goto_next(opts)
    end)
    m('n', '[d', function()
      vim.diagnostic.goto_prev(opts)
    end)
  end,
})

au('TermOpen', {
  pattern = '*',
  callback = function()
    vim.cmd.startinsert()
    m('t', '<C-]>', '<C-\\><C-n>')
    optl.number = false
    optl.signcolumn = 'no'
    optl.foldcolumn = '0'
  end,
})
