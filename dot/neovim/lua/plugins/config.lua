local ui = require 'core.ui'
---@class Plugins.Config
local Config = {}

local api = vim.api
local map = vim.keymap.set
local hl = api.nvim_set_hl
local autocmd = api.nvim_create_autocmd

function Config.tokyonight()
  require('tokyonight').setup {
    sidebars = {},
  }
end

function Config.alpha()
  local alpha = require 'alpha'
  local dashboard = require 'alpha.themes.dashboard'
  local section, button = dashboard.section, dashboard.button
  section.header.val = {
    [[]],
    [[  ／l、     ]],
    [[ (ﾟ､ ｡ ７   ]],
    [[  l  ~ヽ    ]],
    [[  じしf_,)ノ]],
    [[]],
  }
  section.buttons.val = {
    button('h', '  · MRW', '<Cmd>Telescope mr mrw<CR>'),
    button('f', '  · Find file', '<Cmd>Telescope find_files<CR>'),
    button('g', '  · Neogit', '<Cmd>Neogit<CR>'),
    button('e', '  · File explorer', '<Cmd>Neotree<CR>'),
    button('t', '  · Terminal', '<Cmd>terminal<CR>'),
    button('u', '  · Update plugins', '<Cmd>Lazy update<CR>'),
    button('q', '  · Quit', '<Cmd>qa<CR>'),
  }
  local vim_ver = vim.version()
  section.footer.val = 'Neovim v' .. vim_ver.major .. '.' .. vim_ver.minor .. '.' .. vim_ver.patch
  alpha.setup(dashboard.opts)
end

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
      backend = { 'telescope', 'nui', 'builtin' },
    },
  }
end

function Config.notify()
  require('notify').setup {
    timeout = 7000,
    on_open = function(win)
      local buf = api.nvim_win_get_buf(win)
      api.nvim_buf_set_option(buf, 'filetype', 'markdown')
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
    },
    rainbow = {
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

function Config.gitsigns()
  require('gitsigns').setup {
    signs = {
      add = { text = '▍' },
      change = { text = '▍' },
      delete = { text = '▖' },
      topdelete = { text = '▘' },
      changedelete = { text = '▍' },
      untracked = { text = '▍' },
    },
  }
  map('n', '<Space>gr', '<Cmd>Gitsigns reset_hunk<CR>')
  map('n', ']g', '<Cmd>Gitsigns next_hunk<CR>')
  map('n', '[g', '<Cmd>Gitsigns prev_hunk<CR>')
  map('n', '<Space>gp', '<Cmd>Gitsigns preview_hunk_inline<CR>')
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
    show_current_context = false,
    show_current_context_start = false,
    char = '▏',
  }
end

function Config.statuscol()
  require('statuscol').setup { setopt = false }
  autocmd('TermEnter', {
    pattern = '*',
    callback = function()
      vim.opt_local.statuscolumn = ''
    end,
  })
  autocmd('BufWinEnter', {
    pattern = '*',
    callback = function()
      vim.opt.numberwidth = 6
      vim.opt.statuscolumn = ' %=%l %s'
      if vim.bo.filetype == 'NeogitStatus' then
        vim.opt_local.statuscolumn = ' %s'
      end
      if vim.bo.buftype == 'terminal' then
        vim.opt_local.statuscolumn = ''
      end
      for _, v in ipairs {
        'neo-tree',
        'neo-tree-popup',
      } do
        if vim.bo.filetype == v then
          vim.opt_local.statuscolumn = ''
        end
      end
    end,
  })
end

function Config.lastplace()
  require('nvim-lastplace').setup()
end

function Config.luasnip()
  require('luasnip.loaders.from_vscode').lazy_load()
end

function Config.bufferline()
  local hls = {
    modified = {
      fg = {
        attribute = 'fg',
        highlight = '@variable.builtin',
      },
    },
  }
  hls.modified_visible = hls.modified
  hls.modified_selected = hls.modified

  require('bufferline').setup {
    options = {
      mode = 'buffers',
      separator_style = 'none',
      indicator = { style = 'none' },
      modified_icon = '',
      left_trunc_marker = '',
      right_trunc_marker = '',
      show_buffer_icons = true,
      show_buffer_close_icons = false,
      always_show_bufferline = true,
      max_name_length = 20,
      tab_size = 22,
      diagnostics = 'nvim_lsp',
      diagnostics_update_in_insert = true,
      ---@type fun(count: integer, level, diagnostics_dict, context): string
      diagnostics_indicator = function(count, _, _, _)
        return tostring(count)
      end,
      offsets = {
        {
          filetype = 'aerial',
          text = '',
          separator = true,
        },
        {
          filetype = 'neo-tree',
          text = '',
          separator = false,
        },
      },
    },
    highlights = hls,
  }
  map('n', '<Space>bh', '<Cmd>BufferLineCyclePrev<CR>')
  map('n', '<Space>bl', '<Cmd>BufferLineCycleNext<CR>')
end

function Config.bufdelete()
  map('n', '<Space>bd', function()
    if vim.fn.expand('%s'):match '^term://.*' then
      return '<Cmd>Bdelete!<CR>'
    else
      return '<Cmd>Bdelete<CR>'
    end
  end, { expr = true })
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
      prompt_prefix = '   ',
      selection_caret = ' ',
    },
  }
  telescope.load_extension 'mr'
  hl(0, 'TelescopeMatching', { link = 'Search' })
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
  require('satellite').setup {
    winblend = 30,
  }
  hl(0, 'ScrollView', { link = 'BufferCurrent' })
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

  local _s = '❯'
  local sep = ' ' .. _s .. ' '

  local navic = require 'nvim-navic'

  navic.setup {
    icons = kind,
    highlight = true,
    separator = sep,
  }

  hl(0, 'NavicText', { link = 'Winbar' })
  hl(0, 'NavicSeparator', { link = 'NavicText' })

  require 'core.winbar'
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

function Config.lspconfig()
  require 'plugins.lspconfig'
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
      icons = {
        package_installed = status.check,
        package_pending = status.dots,
        package_uninstalled = status.close,
      },
    },
  }
end

function Config.startuptime()
  vim.g.startuptime_tries = 50
end

return Config
