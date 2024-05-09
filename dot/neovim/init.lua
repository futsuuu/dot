_G.config_flags = {
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
  key = {
    i = true,
    n = true,
  },
  lang = {
    rust = true,
    yuck = true,
  },
}

require 'plugins'
require 'rc'
