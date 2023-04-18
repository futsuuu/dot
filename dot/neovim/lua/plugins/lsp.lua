local lsp = vim.lsp

local lspconfig = require 'lspconfig'
local mason_lspconfig = require 'mason-lspconfig'
local cmp_nvim_lsp = require 'cmp_nvim_lsp'
local navic = require 'nvim-navic'

local root_pattern = lspconfig.util.root_pattern

local function get_python_path()
  local venv_path = os.getenv 'VIRTUAL_ENV'
  return venv_path and venv_path .. '/bin/python' or 'python'
end

local function on_attach(client, bufnr)
  local server_cap = client.server_capabilities
  server_cap.documentFormattingProvider = false
  if server_cap.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

local capabilities = lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

mason_lspconfig.setup_handlers {
  function(server_name)
    local opts = {
      on_attach = on_attach,
      capabilities = cmp_nvim_lsp.default_capabilities(capabilities),
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
  ['vtsls'] = function()
    lspconfig.vtsls.setup {
      root_dir = root_pattern('package.json', 'tsconfig.json', 'jsconfig.json'),
    }
  end,
}

lspconfig.denols.setup {
  root_dir = root_pattern('deno.json', 'deno.jsonc', 'deno.lock'),
}

lsp.handlers['textDocument/publishDiagnostics'] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
  signs = false,
  virtual_text = {
    prefix = '',
  },
  float = {
    severity_sort = true,
  },
  update_in_insert = true,
  severity_sort = true,
})

lsp.handlers['textDocument/hover'] = lsp.with(lsp.handlers.hover, { border = 'rounded' })

vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })

local map = vim.keymap.set

map('n', '<Space>ca', function()
  require('actions-preview').code_actions()
end)
map('n', '<Space>rn', vim.lsp.buf.rename)
map('n', ']d', vim.diagnostic.goto_next)
map('n', '[d', vim.diagnostic.goto_prev)
map('n', 'K', vim.lsp.buf.hover)
