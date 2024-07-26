local stdpath = require('rc.utils').stdpath
local ui = require 'rc.ui'

local flags = _G.config_flags

return function(init, config, build)
  local plugins = {
    {
      'sainnhe/edge',
      init = init.edge,
    },
    {
      cond = flags.filer == 'oil',
      'stevearc/oil.nvim',
      cmd = 'Oil',
      init = init.oil,
      config = config.oil,
    },
    {
      cond = flags.telescope,
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      cmd = 'Telescope',
      init = init.telescope,
      config = config.telescope,
      dependencies = {
        {
          'lambdalisue/vim-mr',
          init = init.mr,
          event = 'BufReadPre',
        },
        { 'natecraddock/telescope-zf-native.nvim' },
      },
    },
    {
      cond = flags.cmp,
      'hrsh7th/nvim-cmp',
      config = config.cmp,
    },
    {
      cond = flags.cmp,
      'hrsh7th/cmp-buffer',
      event = 'InsertEnter',
      dependencies = 'nvim-cmp',
    },
    {
      cond = flags.cmp and flags.nvim_lsp,
      'hrsh7th/cmp-nvim-lsp',
      event = 'InsertEnter',
      dependencies = 'nvim-cmp',
    },
    {
      cond = flags.cmp and flags.nvim_lsp,
      'hrsh7th/cmp-nvim-lsp-signature-help',
      event = 'InsertEnter',
      dependencies = 'nvim-cmp',
    },
    {
      cond = flags.cmp,
      'hrsh7th/cmp-path',
      event = { 'InsertEnter', 'CmdlineEnter' },
      dependencies = 'nvim-cmp',
    },
    {
      cond = flags.cmp,
      'hrsh7th/cmp-cmdline',
      event = 'CmdlineEnter',
      dependencies = 'nvim-cmp',
    },
    {
      cond = flags.cmp and flags.nvim_lsp,
      'dcampos/cmp-snippy',
      event = 'InsertEnter',
      dependencies = { 'dcampos/nvim-snippy', 'nvim-cmp' },
    },

    {
      cond = flags.nvim_lsp,
      'neovim/nvim-lspconfig',
      event = { 'BufRead', 'CursorHold' },
      config = config.lsp,
      dependencies = {
        {
          'williamboman/mason-lspconfig.nvim',
          config = config.mason_lspconfig,
          dependencies = 'mason.nvim',
        },
        {
          'folke/neodev.nvim',
          config = config.neodev,
        },
        { 'b0o/schemastore.nvim' },
        {
          'SmiteshP/nvim-navic',
          config = config.navic,
          event = 'BufReadPre',
        },
      },
    },
    {
      cond = flags.nvim_lsp,
      'futsuuu/refs_info.nvim',
      cmd = { 'RefsInfoEnable', 'RefsInfoDisable', 'RefsInfoToggle' },
      config = config.refs_info,
    },

    {
      cond = flags.treesitter,
      'nvim-treesitter/nvim-treesitter',
      cmd = { 'TSUpdate', 'TSInstall', 'TSInstallInfo', 'TSUninstall', 'TSEnable' },
      build = ':TSUpdate',
      event = 'BufRead',
      config = config.treesitter,
      dependencies = {
        'nushell/tree-sitter-nu',
      },
    },

    {
      cond = flags.nvim_lsp and flags.treesitter,
      dir = '~/dev/github.com/zbirenbaum/neodim',
      event = 'LspAttach',
      config = config.neodim,
    },

    {
      cond = flags.nvim_lsp or flags.treesitter,
      'stevearc/aerial.nvim',
      cmd = 'AerialToggle',
      init = init.aerial,
      config = config.aerial,
    },

    {
      cond = flags.nvim_dap,
      'mfussenegger/nvim-dap',
      config = config.dap,
      init = init.dap,
      dependencies = {
        {
          'rcarriga/nvim-dap-ui',
          config = config['dap.ui'],
        },
      },
    },

    {
      cond = flags.denops,
      'vim-denops/denops.vim',
    },
    {
      cond = flags.denops,
      'vim-denops/denops-shared-server.vim',
      build = {
        ':let g:denops#deno = "deno"',
        ':let g:denops_server_addr = "127.0.0.1:32123"',
        ':call denops_shared_server#install()',
      },
    },
    {
      cond = flags.denops and flags.skkeleton,
      'kei-s16/skkeleton-azik-kanatable',
      dependencies = 'skkeleton',
      event = 'VeryLazy',
    },
    {
      'vim-skk/skkeleton',
      init = init.skkeleton,
      config = config.skkeleton,
      dependencies = 'denops.vim',
      build = ':call denops#notify("rc", "downloadJisyo", [])',
    },

    {
      cond = flags.lang.yuck,
      'elkowar/yuck.vim',
      ft = 'yuck',
    },
    {
      cond = flags.lang.log,
      'fei6409/log-highlight.nvim',
      ft = 'log',
    },

    {
      cond = flags.key.i,
      'tani/dmacro.nvim',
      lazy = false,
      config = config.dmacro,
    },
    {
      cond = flags.key.i,
      'hrsh7th/nvim-insx',
      event = { 'InsertEnter', 'CmdlineEnter' },
      config = config.insx,
    },
    {
      cond = flags.key.n,
      'kylechui/nvim-surround',
      version = '*',
      event = 'CursorMoved',
      config = config.nvim_surround,
    },

    {
      cond = flags.git,
      'NeogitOrg/neogit',
      cmd = 'Neogit',
      config = config.neogit,
    },
    {
      cond = flags.git,
      'lewis6991/gitsigns.nvim',
      config = config.gitsigns,
      init = init.gitsigns,
      cmd = 'Gitsigns',
      event = 'BufRead',
    },

    {
      'williamboman/mason.nvim',
      cmd = {
        'Mason',
        'MasonUpdate',
        'MasonInstall',
        'MasonUninstall',
        'MasonUninstallAll',
        'MasonLog',
      },
      build = build.mason,
      config = config.mason,
    },

    {
      'stevearc/overseer.nvim',
      cmd = {
        'OverseerInfo',
        'OverseerOpen',
        'OverseerToggle',
        'OverseerRun',
      },
      init = init.overseer,
      config = config.overseer,
    },

    {
      'tweekmonster/helpful.vim',
      cmd = 'HelpfulVersion',
    },
    {
      'tyru/capture.vim',
      cmd = 'Capture',
    },

    {
      'lambdalisue/vim-suda',
      cmd = {
        'SudaRead',
        'SudaWrite',
      },
      init = init.suda,
    },
    {
      cond = flags.lang.rust,
      'saecki/crates.nvim',
      event = 'BufReadPre Cargo.toml',
      config = config.crates,
    },
    {
      cond = flags.decoration,
      'folke/todo-comments.nvim',
      event = 'BufRead',
      config = config.todo_comments,
    },
    {
      cond = flags.decoration,
      'lukas-reineke/indent-blankline.nvim',
      event = 'CursorMoved',
      config = config.blankline,
    },
    {
      cond = flags.decoration,
      'lewis6991/satellite.nvim',
      event = 'BufRead',
      config = config.satellite,
    },
    {
      cond = flags.decoration,
      'uga-rosa/ccc.nvim',
      init = init.ccc,
      config = config.ccc,
      cmd = {
        'CccPick',
        'CccConvert',
        'CccHighlighterToggle',
        'CccHighlighterDisable',
        'CccHighlighterEnalble',
      },
    },
    {
      cond = flags.decoration,
      'LumaKernel/nvim-visual-eof.lua',
      config = config.visual_eof,
      event = 'BufRead',
    },
    {
      cond = flags.decoration,
      'stevearc/dressing.nvim',
      init = init.dressing,
    },
    {
      cond = flags.decoration,
      'j-hui/fidget.nvim',
      event = { 'LspAttach' },
      config = config.fidget,
      init = init.fidget,
    },
    {
      cond = flags.decoration,
      'RRethy/vim-illuminate',
      event = { 'CursorMoved' },
      config = config.illuminate,
    },
    {
      cond = flags.buffer,
      'backdround/tabscope.nvim',
      event = 'WinEnter',
      config = config.tabscope,
    },
    {
      cond = flags.buffer,
      'famiu/bufdelete.nvim',
      cmd = { 'Bdelete', 'Bwipeout' },
      init = init.bufdelete,
    },

    { 'nvim-neotest/nvim-nio' },
    { 'nvim-lua/plenary.nvim' },
    { 'futsuuu/clico' },
    { 'MunifTanjim/nui.nvim' },

    {
      'ethanholz/nvim-lastplace',
      event = 'BufReadPre',
      config = config.lastplace,
    },
  }

  local lazypath = vim.fs.joinpath(stdpath.data, 'lazy', 'lazy.nvim')
  if not vim.uv.fs_stat(lazypath) then
    vim.fn.system {
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable',
      lazypath,
    }
  end
  vim.opt.rtp:prepend(lazypath)

  require('lazy').setup(plugins, {
    defaults = {
      lazy = true,
    },
    local_spec = false,
    pkg = {
      enabled = false,
    },
    rocks = {
      enabled = false,
    },
    dev = {
      path = '~/dev/github.com/futsuuu',
      patterns = { 'futsuuu' },
      fallback = true,
    },
    concurrency = 10,
    ui = {
      border = 'none',
      icons = {
        loaded = ui.checkbox.check,
        not_loaded = ui.checkbox.close,
        runtime = ' ',
        cmd = ' ',
        event = ' ',
        ft = ' ',
        init = ' ',
        config = ' ',
        import = ' ',
        keys = ' ',
        lazy = '󰒲 ',
        plugin = ' ',
        source = ' ',
        start = ' ',
        task = ' ',
        list = { ' ' },
      },
    },
    performance = {
      rtp = {
        disabled_plugins = {
          'gzip',
          'matchit',
          -- 'matchparen',
          'tarPlugin',
          'tohtml',
          'tutor',
          'zipPlugin',
          'health',
          'shada',
          'spellfile',
          'rplugin',
          -- 'man',
          'netrwPlugin',
          -- 'editorconfig',
          'nvim',
        },
      },
    },
  })
end
