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

local changelog = {
  icon = '',
  color = '#bcae3d',
  name = 'ChangeLog',
}

local todo = {
  icon = '',
  color = '#33ce89',
  name = 'Todo',
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
  color = '#277ded',
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

local package_json = {
  icon = '󰎙',
  color = '#1ec157',
  name = 'PackageJson',
}

local react = {
  icon = '󰜈',
  color = '#2599e6',
  name = 'React',
}

devicons.setup {
  override_by_filename = {
    ['tmux.conf'] = tmux,
    ['.tmux.conf'] = tmux,
    ['.gitconfig'] = git,
    ['.gitignore'] = git,
    ['.gitkeep'] = git,
    ['.gitmodules'] = git,
    ['.gitattributes'] = git,
    ['commit_editmsg'] = git,
    ['readme.md'] = readme,
    ['todo.md'] = todo,
    ['changelog.md'] = changelog,
    ['license'] = license,
    ['package.json'] = package_json,
    ['package-lock.json'] = package_json,
  },
  override_by_extension = {
    lua = lua,
    rs = rust,
    ts = typescript,
    tsx = react,
  },
  default = true,
}

devicons.set_default_icon('', '#729cb1')
