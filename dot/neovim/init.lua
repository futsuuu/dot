_G.config_flags = {
  colorscheme = 'robot',
  main = true,
  nvim_lsp = true,
  denops = true,
  skkeleton = true,
  ddu = true,
  cmp = true,
  alpha = true,
  treesitter = true,
  statuscolumn = true,
  decoration = true,
  buffer = true,
  on_open = true,
  null_ls = true,
}

for _, v in ipairs {
  'utils.table',
  'utils.string',
  'gui',
  'core',
  'plugins',
} do
  require(v)
end
