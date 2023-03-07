local lsp = vim.lsp

local lspconfig = require 'lspconfig'
local mason_lspconfig = require 'mason-lspconfig'
local cmp_nvim_lsp = require 'cmp_nvim_lsp'

local map = vim.keymap.set

map('n', '<Space>rn', function()
  vim.lsp.buf.rename()
end)

map('n', ']d', function()
  vim.diagnostic.goto_next()
end)

map('n', '[d', function()
  vim.diagnostic.goto_prev()
end)

map('n', 'K', function()
  vim.lsp.buf.hover()
end)

mason_lspconfig.setup_handlers {
  function(server_name)
    local opts = {
      on_attach = function(client, _)
        local server_cap = client.server_capabilities
        server_cap.documentFormattingProvider = false
      end,
      capabilities = cmp_nvim_lsp.default_capabilities(
        lsp.protocol.make_client_capabilities()
      ),
      settings = {
        Lua = {
          runtime = {
            version = 'Lua 5.2',
          },
          workspace = {
            checkThirdParty = false,
          },
          completion = {
            callSnippet = 'Replace',
          },
        },
      },
    }
    lspconfig[server_name].setup(opts)
  end,
}

lsp.handlers['textDocument/publishDiagnostics'] =
  lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    signs = false,
    virtual_text = {
      prefix = '',
    },
    update_in_insert = true,
    severity_sort = true,
  })

lsp.handlers['textDocument/hover'] =
  lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
