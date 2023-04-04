---@param init Plugins.Init
---@param config Plugins.Config
return function(init, config)
  local plugins = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-tree/nvim-web-devicons',
      config = config.devicons,
    },
    'MunifTanjim/nui.nvim',
    {
      'folke/tokyonight.nvim',
      config = config.tokyonight,
    },

    {
      'goolord/alpha-nvim',
      config = config.alpha,
      event = 'VimEnter',
    },

    -- edit
    {
      'hrsh7th/nvim-insx',
      event = 'InsertEnter',
      config = config.insx,
    },
    {
      'kylechui/nvim-surround',
      version = '*',
      event = 'CursorMoved',
      config = config.nvim_surround,
    },

    -- completion
    {
      'L3MON4D3/LuaSnip',
      version = '*',
      dependencies = {
        'rafamadriz/friendly-snippets',
      },
      config = config.luasnip,
    },
    {
      --dir = "~/dev/github.com/futsuuu/nvim-cmp",
      'hrsh7th/nvim-cmp',
      config = config.cmp,
    },
    { 'hrsh7th/cmp-buffer', event = 'InsertEnter' },
    { 'hrsh7th/cmp-nvim-lsp', event = 'InsertEnter' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help', event = 'InsertEnter' },
    { 'saadparwaiz1/cmp_luasnip', event = 'InsertEnter' },
    { 'hrsh7th/cmp-path', event = { 'InsertEnter', 'CmdlineEnter' } },
    { 'hrsh7th/cmp-cmdline', event = 'CmdlineEnter' },

    -- buffer
    {
      'akinsho/bufferline.nvim',
      version = 'v3.*',
      event = { 'BufRead', 'TermOpen', 'TabNew' },
      config = config.bufferline,
    },
    {
      'tiagovla/scope.nvim',
      event = 'TabNew',
      config = config.scope,
    },
    {
      'famiu/bufdelete.nvim',
      cmd = { 'Bdelete', 'Bwipeout' },
      event = 'BufAdd',
      config = config.bufdelete,
    },

    {
      'nvim-treesitter/nvim-treesitter',
      module = false,
      build = ':TSUpdate',
      event = 'BufRead',
      config = config.treesitter,
      dependencies = {
        'mrjones2014/nvim-ts-rainbow',
      },
    },
    {
      'luukvbaal/statuscol.nvim',
      event = { 'BufRead', 'TabNew' },
      cond = vim.fn.has 'nvim-0.9' == 1,
      config = config.statuscol,
    },
    {
      'kevinhwang91/nvim-ufo',
      event = { 'BufRead', 'TabNew' },
      config = config.ufo,
      dependencies = {
        'kevinhwang91/promise-async',
      },
    },
    {
      'lukas-reineke/indent-blankline.nvim',
      event = 'CursorMoved',
      config = config.blankline,
    },

    -- git
    {
      'lewis6991/gitsigns.nvim',
      config = config.gitsigns,
      event = 'BufRead',
    },
    {
      'TimUntersberger/neogit',
      dependencies = {
        {
          'sindrets/diffview.nvim',
          cmd = 'DiffviewOpen',
        },
      },
      cmd = 'Neogit',
      config = config.neogit,
    },

    -- ui
    {
      'stevearc/dressing.nvim',
      init = init.dressing,
    },
    {
      'rcarriga/nvim-notify',
      init = init.notify,
    },

    -- lsp
    {
      'williamboman/mason.nvim',
      cmd = {
        'Mason',
        'MasonInstall',
        'MasonUninstall',
        'MasonUninstallAll',
        'MasonLog',
      },
      config = config.mason,
    },
    {
      'neovim/nvim-lspconfig',
      event = { 'BufRead', 'CursorHold' },
      config = config.lspconfig,
      dependencies = {
        {
          'williamboman/mason-lspconfig.nvim',
          config = config.mason_lspconfig,
        },
        {
          'folke/neodev.nvim',
          config = config.neodev,
        },
        {
          'j-hui/fidget.nvim',
          config = config.fidget,
        },
        {
          'SmiteshP/nvim-navic',
          config = config.navic,
          event = 'BufReadPre',
        },
        {
          'aznhe21/actions-preview.nvim',
          config = config.actions_preview,
        },
      },
    },
    {
      'jose-elias-alvarez/null-ls.nvim',
      event = 'BufReadPost',
      config = config.null_ls,
    },

    -- telescope
    {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      cmd = 'Telescope',
      init = init.telescope,
      config = config.telescope,
      dependencies = {
        {
          'natecraddock/telescope-zf-native.nvim',
        },
        {
          'lambdalisue/mr.vim',
          config = config.mr,
          event = 'BufReadPre',
        },
      },
    },

    {
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      cmd = 'Neotree',
      init = init.neotree,
      config = config.neotree,
    },

    -- scroll
    {
      'lewis6991/satellite.nvim',
      event = 'WinScrolled',
      config = config.satellite,
    },

    -- utils
    {
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
      'ethanholz/nvim-lastplace',
      event = 'BufReadPre',
      config = config.lastplace,
    },
    {
      'dstein64/vim-startuptime',
      cmd = 'StartupTime',
      config = config.startuptime,
    },
  }

  local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
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
    concurrency = 10,
    ui = {
      icons = {
        loaded = '',
        not_loaded = '',
        runtime = '',
        list = { ' ' },
      },
    },
    performance = {
      rtp = {
        disabled_plugins = {
          'gzip',
          'matchit',
          'matchparen',
          'tarPlugin',
          'tohtml',
          'tutor',
          'zipPlugin',
          'health',
          'shada',
          'spellfile',
          'rplugin',
          'man',
          'netrwPlugin',
          'editorconfig',
          'nvim',
        },
      },
    },
  })
end
