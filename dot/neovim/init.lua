_G.config_flags = {
  colorscheme = 'edge',
  main = true,
  nvim_lsp = true,
  denops = true,
  skkeleton = true,
  telescope = true,
  cmp = true,
  vsnip = true,
  treesitter = true,
  decoration = true,
  buffer = true,
  on_open = true,
  null_ls = true,
}

vim.opt.background = 'light'

for _, v in ipairs {
  'utils.table',
  'utils.string',
  'gui',
  'core',
  'plugins',
} do
  require(v)
end
