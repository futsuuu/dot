local lsp = vim.lsp

local lspconfig = require 'lspconfig'
local lsp_win = require 'lspconfig.ui.windows'
local mason_lspconfig = require 'mason-lspconfig'

local root_pattern = lspconfig.util.root_pattern

require('utils').on_attach(function(client, bufnr)
  if client.supports_method 'textDocument/inlayHint' then
    pcall(vim.lsp.buf.inlay_hint, bufnr)
  end
end)

local capabilities = lsp.protocol.make_client_capabilities()
capabilities.textDocument = {
  foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  },
  completion = {
    completionItem = {
      snippetSupport = true,
    },
  },
}

if _G.plugin_flags.cmp then
  local cmp_nvim_lsp = require 'cmp_nvim_lsp'
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

local js_ts_inlayhint = {
  enumMemberValues = {
    enabled = true,
  },
  functionLikeReturnTypes = {
    enabled = true,
  },
  parameterNames = {
    enabled = 'all',
    suppressWhenArgumentMatchesName = true,
  },
  parameterTypes = {
    enabled = true,
  },
  propertyDeclarationTypes = {
    enabled = true,
  },
  variableTypes = {
    enabled = true,
    suppressWhenTypeMatchesName = true,
  },
}

local settings = {
  Lua = {
    runtime = {
      version = _VERSION,
    },
    workspace = {
      checkThirdParty = false,
    },
    completion = {
      callSnippet = 'Replace',
      postfix = ':',
    },
    diagnostics = {
      globals = { 'describe', 'it', 'before_each' },
    },
    hover = {
      expandAlias = false,
    },
    hint = {
      enable = true,
    },
  },
  deno = {
    enable = true,
    lint = true,
    unstable = true,
    importMap = './deno.jsonc',
    inlayHints = js_ts_inlayhint,
  },
  ['rust-analyzer'] = {
    check = {
      command = 'clippy',
    },
  },
  typescript = {
    inlayHints = js_ts_inlayhint,
  },
  javascript = {
    inlayHints = js_ts_inlayhint,
  },
}

mason_lspconfig.setup_handlers {
  function(server_name)
    local opts = {
      capabilities = capabilities,
      settings = settings,
    }
    lspconfig[server_name].setup(opts)
  end,
  vtsls = function()
    lspconfig.vtsls.setup {
      capabilities = capabilities,
      settings = settings,
      root_dir = root_pattern('package.json', 'tsconfig.json', 'jsconfig.json'),
      single_file_support = false,
    }
  end,
}

if vim.fn.executable 'deno' then
  lspconfig.denols.setup {
    capabilities = capabilities,
    settings = settings,
    root_dir = root_pattern('deno.json', 'deno.jsonc', 'deno.lock'),
  }
end

vim.diagnostic.config {
  signs = false,
  virtual_text = {
    prefix = '',
  },
  float = {
    severity_sort = true,
  },
  update_in_insert = true,
  severity_sort = true,
}

lsp_win.default_options.border = 'rounded'
lsp.handlers['textDocument/hover'] = lsp.with(lsp.handlers.hover, { border = 'rounded' })
