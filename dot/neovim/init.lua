_G.plugin_flags = {
  colorscheme = 'robot',
  main = true,
  nvim_lsp = true,
  denops = true,
  skkeleton = true,
  ddu = true,
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
