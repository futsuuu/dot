local devicons = require 'nvim-web-devicons'

local tmux = {
  icon = '',
  color = '#70d40d',
  name = 'Tmux',
}

local readme = {
  icon = '',
  color = '#2f9deb',
  name = 'Readme',
}

local license = {
  icon = '',
  color = '#999966',
  name = 'License',
}

local git = {
  icon = '󰊢',
  color = '#f23040',
  name = 'Git',
}

local lua = {
  icon = '󰢱',
  color = '#1a5edb',
  name = 'Lua',
}

local rust = {
  icon = '󱘗',
  color = '#de8c3b',
  name = 'Rust',
}

local typescript = {
  icon = '',
  color = '#4093b7',
  name = 'Ts',
}

devicons.setup {
  override_by_filename = {
    ['tmux.conf'] = tmux,
    ['.tmux.conf'] = tmux,
    ['.gitconfig'] = git,
    ['.gitignore'] = git,
    ['.gitkeep'] = git,
    ['.gitmodules'] = git,
    ['.gitattribules'] = git,
    ['commit_editmsg'] = git,
    ['readme.md'] = readme,
    ['license'] = license,
  },
  override_by_extension = {
    lua = lua,
    rs = rust,
    ts = typescript,
  },
  default = true,
}

devicons.set_default_icon('', '#729cb1')
