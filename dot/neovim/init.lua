_G.config_flags = {
  colorscheme = 'edge',
  nvim_lsp = true,
  denops = vim.fn.executable 'deno' == 1,
  skkeleton = true,
  telescope = true,
  cmp = true,
  vsnip = true,
  treesitter = true,
  decoration = true,
  buffer = true,
  on_open = true,
  git = true,
  filer = 'oil',
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
  'plugins',
  'utils.table',
  'utils.string',
  'gui',
  'core',
} do
  require(v)
end
