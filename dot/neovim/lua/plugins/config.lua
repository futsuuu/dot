local api = vim.api
local hl = api.nvim_set_hl
local autocmd = api.nvim_create_autocmd

local ui = require 'core.ui'
local utils = require 'utils'

local call = utils.call

---@class Plugins.Config
local Config = setmetatable({}, {
  ---@type fun(table: table, key: string): function
  __index = function(_, key)
    return function()
      require('plugins.' .. key)
    end
  end,
})

function Config.alpha()
  local header = [[
 ／l、     
(ﾟ､ ｡ ７   
 l  ~ヽ    
 じしf_,)ノ
]]
  local alpha = require 'alpha'
  local dashboard = require 'alpha.themes.dashboard'
  local section, button = dashboard.section, dashboard.button
  section.header.val = header:split '\n'
  section.buttons.val = {
    button('h', '  · MRW', '<Cmd>Telescope mr mrw<CR>'),
    button('f', '  · Find file', '<Cmd>Telescope find_files<CR>'),
    button('e', '  · File explorer', '<Cmd>Neotree<CR>'),
    button('t', '  · Terminal', '<Cmd>terminal<CR>'),
    button('u', '  · Update plugins', '<Cmd>Lazy update<CR>'),
    button('x', '  · Exit', '<Cmd>qa<CR>'),
  }
  local vim_ver = vim.version()
  if vim_ver then
    section.footer.val = 'Neovim v' .. vim_ver.major .. '.' .. vim_ver.minor .. '.' .. vim_ver.patch
  end
  alpha.setup(dashboard.opts)
end

function Config.insx()
  require('insx.preset.standard').setup()
end

function Config.dressing()
  require('dressing').setup {
    input = {
      default_prompt = '> ',
    },
    select = {
      backend = { 'telescope', 'nui', 'builtin' },
    },
  }
end

function Config.notify()
  require('notify').setup {
    timeout = 7000,
    on_open = function(win)
      api.nvim_set_option_value('filetype', 'markdown', { win = win })
    end,
  }
end

function Config.treesitter()
  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      'lua',
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    rainbow = {
      enable = true,
    },
    autotag = {
      enable = true,
    },
  }
  autocmd('CursorHold', {
    pattern = '*',
    callback = function()
      vim.cmd [[
      TSBufDisable rainbow
      TSBufEnable rainbow
      ]]
    end,
  })
end

function Config.neodim()
  require('neodim').setup {
    update_in_insert = {
      enable = false,
    },
  }
end

function Config.crates()
  local crates = require 'crates'

  crates.setup {
    date_format = '%m/%d, %Y',
    curl_args = { package.config:sub(1, 1) == '/' and '-sL' or '-skL', '--retry', '1' },
    thousands_separator = ',',
    popup = {
      border = 'rounded',
      text = {
        title = ' %s',
        created_label = ' created        ',
        updated_label = ' updated        ',
        downloads_label = ' downloads      ',
        homepage_label = ' homepage       ',
        repository_label = ' repository     ',
        documentation_label = ' documentation  ',
        crates_io_label = ' crates.io      ',
        categories_label = ' categories     ',
        keywords_label = ' keywords       ',
      },
    },
    null_ls = {
      enabled = true,
      name = 'crates',
    },
  }
end

function Config.neogit()
  require('neogit').setup {
    integrations = {
      diffview = true,
    },
    signs = {
      section = { ui.chevron.right, ui.chevron.down },
      item = { ui.chevron.right, ui.chevron.down },
    },
  }
  hl(0, 'NeogitDiffContextHighlight', { link = 'CursorLine' })
  hl(0, 'NeogitDiffAddHighlight', { link = 'DiffAdd' })
  hl(0, 'NeogitDiffDeleteHighlight', { link = 'DiffDelete' })
end

function Config.blankline()
  require('indent_blankline').setup {
    show_first_indent_level = true,
    show_current_context = false,
    show_current_context_start = false,
    char = '▏',
    filetype_exclude = {
      'lspinfo',
      'checkhealth',
      'help',
      'man',
      'OverseerForm',
      '',
    },
  }
end

function Config.gitsigns()
  require('gitsigns').setup {
    signs = {
      add = { text = ' ▍' },
      change = { text = ' ▍' },
      delete = { text = ' ▖' },
      topdelete = { text = ' ▘' },
      changedelete = { text = ' ▍' },
      untracked = { text = ' ▍' },
    },
  }
end

function Config.lastplace()
  require('nvim-lastplace').setup()
end

function Config.skkeleton()
  local skkeleton = call 'skkeleton'

  autocmd('User skkeleton-initialize-pre', {
    callback = function()
      skkeleton.config {
        markerHenkan = '▽ ',
        markerHenkanSelect = '▼ ',
        keepState = true,
        eggLikeNewline = true,
        setUndoPoint = false,
      }

      skkeleton.register_keymap('input', ';', 'henkanPoint')
    end,
  })
end

function Config.luasnip()
  require('luasnip.loaders.from_vscode').lazy_load()
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
      preview = {
        treesitter = true,
      },
      results_title = false,
      prompt_title = false,
      sorting_strategy = 'ascending',
      prompt_prefix = '   ',
      selection_caret = ' ',
    },
  }
  telescope.load_extension 'zf-native'
  telescope.load_extension 'mr'
  hl(0, 'TelescopeMatching', { link = 'Search' })
end

function Config.overseer()
  require('overseer').setup {
    templates = { 'builtin', 'user.python' },
    component_aliases = {
      default = {
        { 'display_duration', detail_level = 2 },
        'on_output_summarize',
        'on_exit_set_status',
        { 'on_complete_notify', statuses = { 'FAILURE' } },
        'on_complete_dispose',
      },
    },
  }
end

function Config.ccc()
  require('ccc').setup {
    bar_char = '󰝤',
    point_char = '⎕', -- not a garbled character
    point_color = '#808080',
  }
end

function Config.neodev()
  require('neodev').setup {
    library = {
      plugins = false,
    },
  }
end

function Config.fidget()
  require('fidget').setup {
    text = {
      spinner = 'arc',
    },
    window = {
      relative = 'editor',
      blend = 0,
    },
    fmt = {
      task = function(task_name, message, percentage)
        return string.format('%s%s %s', message, ui.progressbar(percentage), task_name)
      end,
    },
  }
  hl(0, 'FidgetTask', { link = 'CursorLineNr' })
  hl(0, 'FidgetTitle', { link = 'Title' })
end

function Config.navic()
  local kind = {}
  for k, v in pairs(ui.kind) do
    kind[k] = v .. ' '
  end

  local navic = require 'nvim-navic'

  navic.setup {
    icons = kind,
    highlight = true,
    separator = ui.winbar_sep.context,
  }

  utils.on_attach(function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end
  end)

  hl(0, 'NavicText', { link = 'Winbar' })
  hl(0, 'NavicSeparator', { link = 'NavicText' })
end

function Config.actions_preview()
  require('actions-preview').setup {
    diff = {
      ignore_whitespace = true,
    },
    backend = { 'telescope', 'nui' },
    telescope = require('telescope.themes').get_dropdown(),
  }
end

function Config.mason_lspconfig()
  require('mason-lspconfig').setup {
    ensure_installed = { 'lua_ls' },
  }
end

function Config.mason()
  local status = ui.status
  require('mason').setup {
    providers = {
      'mason.providers.client',
      'mason.providers.registry-api',
    },
    ui = {
      border = 'rounded',
      height = 0.8,
      icons = {
        package_installed = status.check,
        package_pending = status.dots,
        package_uninstalled = status.close,
      },
    },
  }
end

function Config.visual_eof()
  require('visual-eof').setup {
    text_EOL = '',
    text_NOEOL = '󰂭 󱞦',
  }
end

function Config.startuptime()
  vim.g.startuptime_tries = 50
end

return Config
