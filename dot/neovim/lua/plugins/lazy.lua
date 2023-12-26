local flags = _G.config_flags

return function(init, config)
  local plugins = {
    {
      cond = flags.colorscheme == 'edge',
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
          'lambdalisue/mr.vim',
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
    },
    {
      cond = flags.cmp and flags.nvim_lsp,
      'hrsh7th/cmp-nvim-lsp',
      event = 'InsertEnter',
    },
    {
      cond = flags.cmp and flags.nvim_lsp,
      'hrsh7th/cmp-nvim-lsp-signature-help',
      event = 'InsertEnter',
    },
    {
      cond = flags.cmp,
      'hrsh7th/cmp-path',
      event = { 'InsertEnter', 'CmdlineEnter' },
    },
    {
      cond = flags.cmp,
      'hrsh7th/cmp-cmdline',
      event = 'CmdlineEnter',
    },
    {
      cond = flags.cmp and flags.vsnip,
      'hrsh7th/cmp-vsnip',
      event = 'InsertEnter',
    },

    {
      cond = flags.vsnip,
      'hrsh7th/vim-vsnip',
      version = '*',
      dependencies = {
        'hrsh7th/vim-vsnip-integ',
        'rafamadriz/friendly-snippets',
      },
      event = 'InsertEnter',
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
      module = false,
      cmd = { 'TSUpdate', 'TSInstall', 'TSInstallInfo', 'TSUninstall', 'TSEnable' },
      build = ':TSUpdate',
      event = 'BufRead',
      config = config.treesitter,
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
      event = 'VeryLazy',
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
      cond = flags.denops,
      'yuki-yano/denops-lazy.nvim',
    },
    {
      cond = flags.denops and flags.skkeleton,
      'vim-skk/skkeleton',
      keys = { { '<C-j>', '<Plug>(skkeleton-enable)', mode = { 'i', 'c' } } },
      event = 'CursorHold',
      config = function()
        require('denops-lazy').load 'skkeleton'
        config.skkeleton()
      end,
    },

    {
      cond = flags.lang.yuck,
      'elkowar/yuck.vim',
      event = 'VeryLazy',
    },

    {
      cond = flags.map.i,
      'hrsh7th/nvim-insx',
      event = { 'InsertEnter', 'CmdlineEnter' },
      config = config.insx,
    },
    {
      cond = flags.map.n,
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
      build = ':MasonUpdate',
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
      'lambdalisue/suda.vim',
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
      'nacro90/numb.nvim',
      event = 'CmdlineEnter',
      config = config.numb,
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
      cond = flags.buffer,
      'akinsho/bufferline.nvim',
      version = '*',
      event = { 'BufRead', 'TermOpen', 'TabNew' },
      config = config.bufferline,
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

    { 'nvim-lua/plenary.nvim' },
    {
      'nvim-tree/nvim-web-devicons',
      config = config.devicons,
    },
    { 'MunifTanjim/nui.nvim' },

    {
      'ethanholz/nvim-lastplace',
      event = 'BufReadPre',
      config = config.lastplace,
    },
  }

  local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
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

  local ui = require 'core.ui'
  require('lazy').setup(plugins, {
    defaults = {
      lazy = true,
    },
    dev = {
      path = '~/dev/github.com/futsuuu',
      patterns = { 'futsuuu' },
      fallback = true,
    },
    concurrency = 10,
    install = {
      colorscheme = { flags.colorscheme },
    },
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
