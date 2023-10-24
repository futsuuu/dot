local null_ls = require 'null-ls'
local builtins = null_ls.builtins

require('utils').lsp.on_attach(function(client, _)
  if client.name ~= 'null-ls' then
    client.server_capabilities.documentFormattingProvider = false
  end
end)

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
  border = 'none',
}
