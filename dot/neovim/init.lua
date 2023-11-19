_G.config_flags = {
  colorscheme = 'edge',
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
  git = true,
  map = {
    i = true,
    n = true,
  },
  lang = {
    rust = true,
    yuck = true,
  },
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
