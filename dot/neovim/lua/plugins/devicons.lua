local devicons = require 'nvim-web-devicons'

local tmux = {
  icon = '',
  color = '#70d40d',
  name = 'Tmux',
}

local doc = {
  icon = '',
  color = '#9dc0eb',
  name = 'Document',
}

local git = {
  icon = '',
  color = '#d73e17',
  name = 'Git',
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
    ['readme.md'] = doc,
    ['license'] = doc,
  },
  default = true,
}

devicons.set_default_icon('', '#729cb1')
