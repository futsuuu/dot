local lsp = vim.lsp

local lspconfig = require 'lspconfig'
local mason_lspconfig = require 'mason-lspconfig'
local cmp_nvim_lsp = require 'cmp_nvim_lsp'
local navic = require 'nvim-navic'

local function get_python_path()
  local venv_path = os.getenv 'VIRTUAL_ENV'
  return venv_path and venv_path .. '/bin/python' or 'python'
end

mason_lspconfig.setup_handlers {
  function(server_name)
    local opts = {
      on_attach = function(client, bufnr)
        local server_cap = client.server_capabilities
        server_cap.documentFormattingProvider = false
        if server_cap.documentSymbolProvider then
          navic.attach(client, bufnr)
        end
      end,
      capabilities = cmp_nvim_lsp.default_capabilities(lsp.protocol.make_client_capabilities()),
      settings = {
        Lua = {
          runtime = {
            version = _VERSION,
          },
          workspace = {
            checkThirdParty = false,
          },
          completion = {
            callSnippet = 'Replace',
          },
        },
        python = {
          pythonPath = get_python_path(),
        },
        ['rust-analyzer'] = {
          check = {
            command = 'clippy',
          },
        },
      },
    }
    lspconfig[server_name].setup(opts)
  end,
}

lsp.handlers['textDocument/publishDiagnostics'] = lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  signs = false,
  virtual_text = {
    prefix = '',
  },
  update_in_insert = true,
  severity_sort = true,
})

lsp.handlers['textDocument/hover'] = lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })

vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })

local map = vim.keymap.set

map('n', '<Space>rn', function()
  vim.lsp.buf.rename()
end)

map('n', '<Space>ca', function()
  vim.lsp.buf.code_action()
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
