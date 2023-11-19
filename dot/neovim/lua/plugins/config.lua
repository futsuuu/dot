local api = vim.api
local hl = api.nvim_set_hl
local autocmd = api.nvim_create_autocmd
local m = vim.keymap.set

local ui = require 'core.ui'
local utils = require 'utils'

local call = utils.call

local Config = setmetatable({}, {
  ---@type fun(table: table, key: string): function
  __index = function(_, key)
    return function()
      require('plugins.' .. key)
    end
  end,
})

function Config.dressing()
  require('dressing').setup {
    input = {
      default_prompt = '> ',
    },
    select = {
      backend = { 'telescope', 'nui', 'builtin' },
      nui = {
        border = 'none',
      },
      builtin = {
        border = 'none',
      },
    },
  }
end

function Config.notify()
  require('notify').setup {
    timeout = 3000,
    on_open = function(win)
      local buf = api.nvim_win_get_buf(win)
      api.nvim_set_option_value('filetype', 'markdown', { buf = buf })
    end,
  }
end

function Config.treesitter()
  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      'lua',
    },
    indent = {
      enable = true,
    },
    highlight = {
      enable = true,
      disable = { 'tsx' },
      additional_vim_regex_highlighting = false,
    },
  }
end

function Config.neodim()
  require('neodim').setup {
    update_in_insert = {
      enable = false,
    },
  }
end

function Config.aerial()
  require('aerial').setup {
    backends = { 'lsp', 'treesitter', 'markdown', 'man' },
    layout = {
      default_direction = 'right',
      min_width = { 20, 0.2 },
    },
    close_on_select = true,
    icons = ui.kind,
    show_guides = true,
    guides = {
      mid_item = '│ ',
      last_item = '│ ',
      nested_top = '│ ',
      whitespace = '  ',
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
      border = 'none',
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
  }
end

function Config.neogit()
  require('neogit').setup {
    integrations = {
      diffview = false,
    },
    signs = {
      section = { ui.chevron.right, ui.chevron.down },
      item = { ui.chevron.right, ui.chevron.down },
    },
  }
  autocmd('FileType', {
    pattern = 'NeogitStatus',
    callback = function()
      vim.schedule(function()
        vim.cmd.stopinsert()
      end)
    end,
  })
  hl(0, 'NeogitDiffContextHighlight', { link = 'CursorLine' })
  hl(0, 'NeogitDiffAddHighlight', { link = 'DiffAdd' })
  hl(0, 'NeogitDiffDeleteHighlight', { link = 'DiffDelete' })
end

function Config.todo_comments()
  local tc = require 'todo-comments'
  tc.setup {
    signs = false,
  }
  m('n', ']t', tc.jump_next)
  m('n', '[t', tc.jump_prev)
end

function Config.blankline()
  require('ibl').setup {
    indent = {
      char = '▏',
    },
    scope = {
      enabled = true,
      highlight = 'CursorLineNr',
      show_start = false,
      show_end = false,
    },
    exclude = {
      filetypes = {
        'lspinfo',
        'checkhealth',
        'help',
        'man',
        'OverseerForm',
        '',
      },
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
    preview_config = {
      border = 'none',
    },
  }
end

function Config.lastplace()
  require('nvim-lastplace').setup()
end

function Config.skkeleton()
  local skkeleton = call 'skkeleton'

  autocmd('User', {
    pattern = ' skkeleton-initialize-pre',
    callback = function()
      skkeleton.config {
        markerHenkan = ' ',
        markerHenkanSelect = ' ',
        keepState = true,
        eggLikeNewline = true,
        setUndoPoint = false,
        userJisyo = vim.fn.stdpath 'data' .. 'SKK-JISYO.user',
      }

      skkeleton.register_keymap('input', ';', 'henkanPoint')
    end,
  })
end

function Config.tabscope()
  require('tabscope').setup {}
end

function Config.nvim_surround()
  require('nvim-surround').setup()
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
    task_list = {
      direction = 'right',
      bindings = {
        h = 'DecreaseDetail',
        l = 'IncreaseDetail',
      },
    },
    form = { winblend = vim.o.winblend },
    confirm = { winblend = vim.o.winblend },
    task_win = { winblend = vim.o.winblend },
  }
  autocmd('FileType', {
    pattern = 'OverseerList',
    callback = function()
      m('n', '<C-h>', '<C-w>h')
      m('n', '<C-l>', '<C-w>l')
      m('n', 'q', '<Cmd>close<CR>')
    end,
  })
end

function Config.ccc()
  local ccc = require 'ccc'
  ccc.setup {
    bar_char = '󰝤',
    point_char = '⎕', -- not a garbled character
    point_color = '#808080',
    pickers = {
      ccc.picker.ansi_escape(),
    },
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
  require('fidget.spinners').dot_wave = {
    '( 󰧞 ·   · )',
    '(  󰧞 ·   )',
    '(   󰧞 · )',
    '(    󰧞 )',
    '( 󰧞    )',
    '( · 󰧞   )',
    '(   · 󰧞  )',
    '( ·   · 󰧞 )',
  }
  require('fidget').setup {
    text = {
      spinner = 'dot_wave',
      done = ui.status.success,
      commenced = ui.status.running,
      completed = ui.status.success,
    },
    window = {
      relative = 'editor',
      blend = 0,
    },
    fmt = {
      fidget = function(fidget_name, spinner)
        return ('%s %s '):format(spinner, fidget_name)
      end,
      task = function(task_name, message, percentage)
        return ('%s%s %s '):format(message, ui.progressbar(percentage), task_name)
      end,
    },
  }
end

function Config.satellite()
  require('satellite').setup {
    winblend = 60,
  }
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

  utils.lsp.on_attach(function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end
  end)

  hl(0, 'NavicText', { link = 'Winbar' })
  hl(0, 'NavicSeparator', { link = 'NavicText' })
end

function Config.mason_lspconfig()
  require('mason-lspconfig').setup()
end

function Config.mason()
  local cb = ui.checkbox
  local mason = require 'mason'
  local registry = require 'mason-registry'

  local packages = {
    'lua-language-server',
    'stylua',
    'selene',
    'efm',
  }

  local function i(depends, servers)
    if type(depends) == 'string' then
      depends = { depends }
    end
    if type(servers) == 'string' then
      servers = { servers }
    end
    for _, cmd in ipairs(depends) do
      if not vim.fn.executable(cmd) then
        return
      end
    end
    for _, server in ipairs(servers) do
      table.insert(packages, server)
    end
  end

  i('npm', { 'json-lsp', 'css-lsp', 'html-lsp', 'vtsls' })
  i('cargo', 'rust-analyzer')
  i('python', 'black')
  i({ 'python', 'npm' }, 'pyright')

  mason.setup {
    providers = {
      'mason.providers.client',
      'mason.providers.registry-api',
    },
    ui = {
      border = 'none',
      height = 0.8,
      icons = {
        package_installed = cb.check,
        package_pending = cb.dots,
        package_uninstalled = cb.close,
      },
    },
  }

  registry.refresh(function()
    for _, pkg_name in ipairs(packages) do
      local pkg = registry.get_package(pkg_name)
      if not pkg:is_installed() then
        pkg:install()
      end
    end
  end)
end

function Config.visual_eof()
  require('visual-eof').setup {
    text_EOL = '',
    text_NOEOL = ' ',
  }
end

function Config.startuptime()
  vim.g.startuptime_tries = 50
end

return Config
