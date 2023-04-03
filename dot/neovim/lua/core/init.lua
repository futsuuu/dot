local opt = vim.opt

local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set

local colorscheme = 'robot'

opt.syntax = 'off'

opt.cmdheight = 0
opt.laststatus = 0
opt.termguicolors = true

autocmd('InsertEnter', {
  pattern = '*',
  callback = function()
    opt.showmode = false
    map('i', 'jj', '<Esc>')
  end,
})

autocmd('WinNew', {
  pattern = '*',
  once = true,
  callback = function()
    map('n', '<C-h>', '<C-w>h')
    map('n', '<C-j>', '<C-w>j')
    map('n', '<C-k>', '<C-w>k')
    map('n', '<C-l>', '<C-w>l')
  end,
})

autocmd('CursorMoved', {
  pattern = '*',
  callback = function()
    opt.cursorline = true
    opt.scrolloff = 10
    opt.sidescroll = 1
    opt.sidescrolloff = 16
    opt.virtualedit = 'onemore'
    opt.wrap = false
    map('n', '<Esc><Esc>', '<Cmd>nohlsearch<CR><Esc>')
  end,
})

autocmd('BufRead', {
  pattern = '*',
  once = true,
  callback = function()
    opt.backup = false
    opt.writebackup = false
    opt.swapfile = false
    opt.syntax = 'on'

    opt.encoding = 'utf-8'
    opt.fileencodings = 'utf-8'
    opt.fileformats = 'unix'

    opt.clipboard = 'unnamedplus'

    opt.hlsearch = true
    opt.incsearch = true
    opt.ignorecase = true
    opt.smartcase = true

    opt.autoread = true
    opt.list = true
    opt.listchars = { trail = '╴', tab = '›─', extends = '' }
    opt.autochdir = false
    opt.autoindent = true
    opt.smartindent = true
    opt.expandtab = true
    opt.shiftwidth = 2
    opt.tabstop = 2
    opt.softtabstop = 2

    opt.number = true
    opt.signcolumn = 'yes'
    map('n', 'a', function()
      return string.match(vim.api.nvim_get_current_line(), '^%s*$') and 'S' or 'a'
    end, { expr = true })
  end,
})

autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    vim.cmd.startinsert()
    map('t', '<Esc>', '<C-\\><C-n>')
    vim.opt_local.number = false
    vim.opt_local.signcolumn = 'no'
  end,
})

require 'plugins'
vim.cmd.colorscheme(colorscheme)
