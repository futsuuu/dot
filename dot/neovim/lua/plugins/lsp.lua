local lsp = vim.lsp

local lspconfig = require 'lspconfig'
local lsp_win = require 'lspconfig.ui.windows'
local mason_lspconfig = require 'mason-lspconfig'

local root_pattern = lspconfig.util.root_pattern

local function on_attach(client, _)
  client.server_capabilities.documentFormattingProvider = false
end

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
  },
  python = {
    pythonPath = (function()
      local venv_path = os.getenv 'VIRTUAL_ENV'
      if venv_path then
        if package.config:sub(1, 1) == '\\' then
          venv_path = venv_path .. '\\Scripts\\python.exe'
        else
          venv_path = venv_path .. '/bin/python'
        end
      end
      return venv_path or 'python'
    end)(),
  },
  deno = {
    enable = true,
    lint = true,
    unstable = true,
    importMap = './deno.jsonc',
  },
  ['rust-analyzer'] = {
    check = {
      command = 'clippy',
    },
  },
}

mason_lspconfig.setup_handlers {
  function(server_name)
    local opts = {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = settings,
    }
    lspconfig[server_name].setup(opts)
  end,
  vtsls = function()
    lspconfig.vtsls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = root_pattern('package.json', 'tsconfig.json', 'jsconfig.json'),
      single_file_support = false,
    }
  end,
}

lspconfig.denols.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = settings,
  root_dir = root_pattern('deno.json', 'deno.jsonc', 'deno.lock'),
}

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
