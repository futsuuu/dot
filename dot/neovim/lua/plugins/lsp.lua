local lsp = vim.lsp
local inlay_hint = lsp.inlay_hint

local configs = require 'lspconfig.configs'
local lsp_win = require 'lspconfig.ui.windows'
local lspconfig = require 'lspconfig'
local mason_lspconfig = require 'mason-lspconfig'

local root_pattern = lspconfig.util.root_pattern

require('rc.utils').lsp.on_attach(function(client, bufnr)
  if client.name ~= 'efm' then
    client.server_capabilities.documentFormattingProvider = false
  end

  if client.supports_method 'textDocument/inlayHint' and inlay_hint then
    vim.api.nvim_buf_create_user_command(bufnr, 'InlayHintToggle', function()
      inlay_hint.enable(not inlay_hint.is_enabled(bufnr), { bufnr = bufnr })
    end, {})
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

if _G.config_flags.cmp then
  local cmp_nvim_lsp = require 'cmp_nvim_lsp'
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

if not configs.nu_ls then
  configs.nu_ls = {
    default_config = {
      cmd = { 'nu', '--lsp' },
      filetypes = { 'nu' },
      root_dir = root_pattern('config.nu', 'env.nu'),
    },
  }
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
    inlayHints = js_ts_inlayhint,
    suggest = {
      autoImports = false,
    },
  },
  ['rust-analyzer'] = {
    lru = {
      capacity = 64,
    },
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
  json = {
    schemas = require('schemastore').json.schemas(),
    validate = { enable = true },
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
  rust_analyzer = function()
    lspconfig.rust_analyzer.setup {
      capabilities = capabilities,
      settings = settings,
      autostart = false,
    }
  end,
  efm = function()
    lspconfig.efm.setup {
      init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
      },
      settings = {
        rootMarkers = {
          '.git/',
        },
        languages = {
          lua = {
            {
              formatCommand = 'stylua --color Never -s -',
              formatStdin = true,
              rootMarkers = {
                'stylua.toml',
                '.stylua.toml',
              },
            },
          },
          rust = {
            {
              formatCommand = 'rustfmt --color=never --emit=stdout --edition=2021',
              formatStdin = true,
              rootMarkers = {
                'rustfmt.toml',
                '.rustfmt.toml',
                'Cargo.lock',
                'Cargo.toml',
              },
            },
          },
        },
      },
    }
  end,
}

if vim.fn.executable 'rust-analyzer' then
  lspconfig.rust_analyzer.setup {
    capabilities = capabilities,
    settings = settings,
    autostart = false,
  }
end

if vim.fn.executable 'deno' then
  lspconfig.denols.setup {
    capabilities = capabilities,
    settings = settings,
    root_dir = root_pattern('deno.json', 'deno.jsonc', 'deno.lock', 'deps.ts'),
  }
end

if vim.fn.executable 'nu' then
  lspconfig.nu_ls.setup {
    autostart = false,
  }
end

if vim.fn.executable 'nil' then
  lspconfig.nil_ls.setup {}
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

lsp_win.default_options.border = 'none'
lsp.handlers['textDocument/hover'] = lsp.with(lsp.handlers.hover, { border = 'none' })
