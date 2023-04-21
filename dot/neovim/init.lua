vim.cmd.colorscheme 'robot'

_G.plugin_flags = {
  main = true,
  nvim_lsp = true,
  cmp = true,
  alpha = true,
  telescope = true,
  treesitter = true,
  foldcolumn = true,
}

for _, v in ipairs {
  'utils.string',
  'gui',
  'core',
  'plugins',
} do
  require(v)
end
