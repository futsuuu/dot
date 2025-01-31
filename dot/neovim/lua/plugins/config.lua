local api = vim.api
local autocmd = api.nvim_create_autocmd
local m = vim.keymap.set

local hl = require('rc.highlight')
local ui = require('rc.ui')
local utils = require('rc.utils')

local config = setmetatable({}, {
  ---@type fun(table: table, key: string): function
  __index = function(_, key)
    return function()
      require('plugins.' .. key)
    end
  end,
})

function config.dressing()
  require('dressing').setup({
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
  })
end

function config.oil()
  require('oil').setup({
    columns = {
      'size',
      { 'icon', directory = '' },
    },
    win_options = {
      number = false,
    },
    view_options = {
      show_hidden = true,
    },
  })
end

function config.treesitter()
  require('nvim-treesitter.configs').setup({
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
  })
end

function config.neodim()
  require('neodim').setup({
    regex = {
      rust = {
        'warn%(unused_mut%)',
      },
    },
  })
end

function config.aerial()
  require('aerial').setup({
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
  })
end

function config.crates()
  local crates = require('crates')

  crates.setup({
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
  })
end

function config.neogit()
  require('neogit').setup({
    integrations = {
      diffview = false,
    },
    signs = {
      section = { ui.chevron.right, ui.chevron.down },
      item = { ui.chevron.right, ui.chevron.down },
    },
  })
  autocmd('FileType', {
    pattern = 'NeogitStatus',
    callback = function()
      vim.schedule(function()
        vim.cmd.stopinsert()
      end)
    end,
  })
  hl.set({
    NeogitDiffContextHighlight = 'CursorLine',
    NeogitDiffAddHighlight = 'DiffAdd',
    NeogitDiffDeleteHighlight = 'DiffDelete',
  })
end

function config.numb()
  require('numb').setup()
end

function config.todo_comments()
  local tc = require('todo-comments')
  tc.setup({
    signs = false,
  })
  m('n', ']t', tc.jump_next)
  m('n', '[t', tc.jump_prev)
end

function config.blankline()
  require('ibl').setup({
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
  })
end

function config.gitsigns()
  local signs = {
    add = { text = ' ▌' },
    change = { text = ' ▌' },
    delete = { text = ' ▖' },
    topdelete = { text = ' ▘' },
    changedelete = { text = ' ▌' },
    untracked = { text = ' ▌' },
  }
  require('gitsigns').setup({
    signs = signs,
    signs_staged = signs,
    preview_config = {
      border = 'none',
    },
  })
end

function config.lastplace()
  require('nvim-lastplace').setup()
end

function config.skkeleton()
  local denops = utils.fn.denops
  local skkeleton = utils.fn.skkeleton

  denops.plugin.wait_async('skkeleton', function()
    skkeleton.azik.add_table('us')

    skkeleton.config({
      kanaTable = 'azik',
      markerHenkan = '∘',
      markerHenkanSelect = '•',
      keepState = true,
      eggLikeNewline = true,
      setUndoPoint = false,
      globalDictionaries = { vim.fs.joinpath(utils.stdpath.data, 'SKK-JISYO.L') },
      userDictionary = vim.fs.joinpath(utils.stdpath.data, 'SKK-JISYO.user'),
    })

    skkeleton.register_keymap('input', ';', 'henkanPoint')
    skkeleton.register_kanatable('azik', {
      l = { 'っ' },
    })
  end)
end

function config.tabscope()
  require('tabscope').setup({})
end

function config.dmacro()
  vim.keymap.set({ 'i', 'n' }, '<C-t>', '<Plug>(dmacro-play-macro)')
end

function config.nvim_surround()
  require('nvim-surround').setup()
end

function config.overseer()
  require('overseer').setup({
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
  })
  autocmd('FileType', {
    pattern = 'OverseerList',
    callback = function()
      m('n', 'q', '<Cmd>close<CR>')
    end,
  })
  hl.set({ OverSeerFAILURE = 'ErrorMsg', OverSserCANCELED = 'WarningMsg', OverSeerTaskBorder = 'WinSeparator' })
end

function config.ccc()
  local ccc = require('ccc')
  ccc.setup({
    bar_char = '󰝤',
    point_char = '⎕', -- not a garbled character
    point_color = '#808080',
  })
end

function config.neodev()
  require('neodev').setup({
    library = {
      plugins = false,
    },
  })
end

function config.fidget()
  require('fidget.spinner.patterns').dot_wave = {
    '( 󰧞 ·   · )',
    '(  󰧞 ·   )',
    '(   󰧞 · )',
    '(    󰧞 )',
    '( 󰧞    )',
    '( · 󰧞   )',
    '(   · 󰧞  )',
    '( ·   · 󰧞 )',
  }
  require('fidget').setup({
    progress = {
      display = {
        done_icon = ui.status.success .. ' ',
        progress_icon = { 'dot_wave' },
        format_message = function(msg)
          local message = msg.message ---@type string?
          local per = msg.percentage ---@type integer?

          if not message then
            message = msg.done and ui.status.success or ui.status.running
          end
          message = message .. ui.progressbar(per)

          return message
        end,
      },
    },
    notification = {
      configs = {
        default = {
          name = 'notification',
          icon = ' ',
          ttl = 5,
          debug_annote = ' ',
          info_annote = ' ',
          warn_annote = ' ',
          error_annote = ' ',
        },
      },
      window = {
        winblend = 0,
        x_padding = 2,
        y_padding = 1,
      },
      view = {
        group_separator = '────────────── ',
      },
    },
  })
end

function config.illuminate()
  require('illuminate').configure({
    delay = 300,
    filetypes_denylist = { 'aerial' },
    modes_denylist = { 'i' },
  })
end

function config.satellite()
  require('satellite').setup({
    winblend = 60,
  })
  hl.get('Normal'):reverse():clear_fg():set('SatelliteBar')
  hl.get('SatelliteBar'):extend('@none'):bold(true):set('SatelliteCursor')
end

function config.navic()
  local kind = {}
  for k, v in pairs(ui.kind) do
    kind[k] = v .. ' '
  end

  local navic = require('nvim-navic')

  navic.setup({
    icons = kind,
    highlight = true,
    separator = ui.winbar_sep.context,
  })

  utils.lsp.on_attach(function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end
  end)

  hl.set({
    NavicText = 'Winbar',
    NavicSeparator = 'NavicText',
  })
end

function config.refs_info()
  require('refs_info').setup()
end

function config.mason_lspconfig()
  require('mason-lspconfig').setup()
end

function config.mason()
  local cb = ui.checkbox
  local mason = require('mason')

  mason.setup({
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
  })
end

function config.visual_eof()
  require('visual-eof').setup({
    text_EOL = '',
    text_NOEOL = ' ',
  })
end

function config.startuptime()
  vim.g.startuptime_tries = 50
end

return config
