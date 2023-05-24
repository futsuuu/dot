local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

local null_ls = require 'null-ls'
local builtins = null_ls.builtins

null_ls.setup {
  sources = {
    builtins.formatting.stylua,
    builtins.formatting.rustfmt,
    builtins.formatting.deno_fmt,
    builtins.formatting.black,
    builtins.diagnostics.selene.with {
      condition = function(utils)
        return utils.root_has_file { 'selene.toml' }
      end,
    },
  },
  default_timeout = 100000,
  border = 'rounded',
  on_attach = function(client, bufnr)
    if client.supports_method 'textDocument/formatting' then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format {
            bufnr = bufnr,
          }
        end,
      })
    end
  end,
}
