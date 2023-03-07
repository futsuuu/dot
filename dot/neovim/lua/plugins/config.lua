---@class Plugins.Config
local Config = {}

local map = vim.keymap.set

function Config.insx()
  require('insx.preset.standard').setup()
end

function Config.cmp()
  require 'plugins.cmp'
end

function Config.dressing()
  require('dressing').setup {
    input = {
      default_prompt = '> ',
    },
    select = {
      backend = { 'nui', 'builtin' },
    },
  }
end

function Config.notify()
  require('notify').setup {
    timeout = 7000,
    on_open = function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
    end,
  }
end

function Config.gitsigns()
  require('gitsigns').setup {
    signs = {
      add = { text = '▕▏' },
      change = { text = '▕▏' },
      delete = { text = '▸ ' },
      topdelete = { text = '▸ ' },
      changedelete = { text = '▕▏' },
      untracked = { text = '▕▏' },
    },
  }
  map('n', '<Space>gr', '<Cmd>Gitsigns reset_hunk<CR>')
  map('n', ']g', '<Cmd>Gitsigns next_hunk<CR>')
  map('n', '[g', '<Cmd>Gitsigns prev_hunk<CR>')
  map('n', '<Space>gp', '<Cmd>Gitsigns preview_hunk_inline<CR>')
end

function Config.blankline()
  require('indent_blankline').setup {
    show_current_context = false,
    show_current_context_start = false,
    char = '▏',
  }
end

function Config.lastplace()
  require('nvim-lastplace').setup()
end

function Config.luasnip()
  require('luasnip.loaders.from_vscode').lazy_load()
end

function Config.bufferline()
  require 'plugins.bufferline'
  map('n', '<Space>bh', '<Cmd>BufferLineCyclePrev<CR>')
  map('n', '<Space>bl', '<Cmd>BufferLineCycleNext<CR>')
  map('n', '<Space>bd', '<Cmd>Bdelete<CR>')
end

function Config.scope()
  require('scope').setup()
end

function Config.nvim_surround()
  require('nvim-surround').setup()
end

function Config.telescope()
  local telescope = require 'telescope'
  telescope.setup {
    defaults = {
      layout_config = {
        horizontal = {
          prompt_position = 'top',
          width = 0.9,
          height = 0.9,
        },
      },
      results_title = false,
      prompt_title = false,
      sorting_strategy = 'ascending',
      prompt_prefix = '   ',
      selection_caret = ' ',
      borderchars = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
    },
  }
  local hl = vim.api.nvim_set_hl
  hl(0, 'TelescopePromptBorder', { link = 'CursorLine' })
  hl(0, 'TelescopePromptCounter', { link = 'CursorLineFold' })
  hl(0, 'TelescopeMatching', { link = 'Search' })
  hl(0, 'TelescopeTitle', { reverse = true })
end

function Config.neotree()
  require 'plugins.neotree'
end

function Config.devicons()
  local devicons = require 'nvim-web-devicons'
  local tmux = {
    icon = '',
    color = '#70d40d',
    name = 'Tmux',
  }
  local doc = {
    icon = '',
    color = '#9dc0eb',
    name = 'Document',
  }
  local git = {
    icon = '',
    color = '#d73e17',
    name = 'Git',
  }
  devicons.setup {
    override_by_filename = {
      ['tmux.conf'] = tmux,
      ['.tmux.conf'] = tmux,
      ['.gitconfig'] = git,
      ['.gitignore'] = git,
      ['.gitkeep'] = git,
      ['.gitmodules'] = git,
      ['.gitattribules'] = git,
      ['commit_editmsg'] = git,
      ['readme.md'] = doc,
      ['license'] = doc,
    },
  }
  devicons.set_default_icon('', '#729cb1')
end

function Config.satellite()
  require('satellite').setup()
end

function Config.ccc()
  require('ccc').setup()
end

function Config.neodev()
  require('neodev').setup {
    library = {
      plugins = false,
    },
  }
end

function Config.null_ls()
  require 'plugins.null-ls'
end

function Config.fidget()
  require('fidget').setup {
    text = {
      spinner = 'arc',
    },
  }
end

function Config.lspconfig()
  require 'plugins.lspconfig'
end

function Config.mason_lspconfig()
  require('mason-lspconfig').setup {
    ensure_installed = { 'lua_ls' },
  }
end

function Config.mason()
  local ui = require('core.ui').status
  require('mason').setup {
    providers = {
      'mason.providers.client',
      'mason.providers.registry-api',
    },
    ui = {
      icons = {
        package_installed = ui.check,
        package_pending = ui.dots,
        package_uninstalled = ui.close,
      },
    },
  }
end

function Config.startuptime()
  vim.g.startuptime_tries = 50
end

return Config