local opt = vim.opt

local au = vim.api.nvim_create_autocmd
local m = vim.keymap.set

opt.syntax = 'off'

opt.cmdheight = 0
opt.laststatus = 0
opt.termguicolors = true
opt.fillchars:append {
  eob = ' ',
}

opt.shell = 'nu'
opt.shellcmdflag = '-c'
opt.shellxquote = ''

require 'core.restore_dir'

au('InsertEnter', {
  pattern = '*',
  once = true,
  callback = function()
    opt.showmode = false
    m('i', 'jj', '<Esc>')
  end,
})

au('WinNew', {
  pattern = '*',
  once = true,
  callback = function()
    opt.statusline = "%{''}"
    opt.fillchars:append {
      stl = '─',
      stlnc = '─',
    }
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

    opt.number = true
    opt.signcolumn = 'yes'

    m('n', 'a', function()
      return vim.api.nvim_get_current_line():match '^%s*$' and 'S' or 'a'
    end, { expr = true })

    m('n', 'K', function()
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
    end)

    m('n', 'mr', vim.lsp.buf.rename)
    m('n', 'md', vim.lsp.buf.definition)
    m('n', 'mf', vim.lsp.buf.format)

    local opts = { float = { border = 'rounded' } }

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
    m('t', '<Esc>', '<C-\\><C-n>')
    vim.opt_local.number = false
    vim.opt_local.signcolumn = 'no'
  end,
})
