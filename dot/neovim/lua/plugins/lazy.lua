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
    'folke/tokyonight.nvim',

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
    { 'saadparwaiz1/cmp_luasnip', event = 'InsertEnter' },
    { 'hrsh7th/cmp-path', event = { 'InsertEnter', 'CmdlineEnter' } },
    { 'hrsh7th/cmp-cmdline', event = 'CmdlineEnter' },

    -- buffer
    {
      'akinsho/bufferline.nvim',
      version = 'v3.*',
      event = { 'BufRead', 'TermOpen' },
      config = config.bufferline,
    },
    {
      'tiagovla/scope.nvim',
      event = 'BufLeave',
      config = config.scope,
    },
    {
      'famiu/bufdelete.nvim',
      cmd = { 'Bdelete', 'Bwipeout' },
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
      event = 'BufRead',
      cond = vim.fn.has 'nvim-0.9' == 1,
      config = config.statuscol,
    },
    {
      'lukas-reineke/indent-blankline.nvim',
      event = 'CursorMoved',
      config = config.blankline,
    },
    {
      'lewis6991/gitsigns.nvim',
      config = config.gitsigns,
      event = 'BufRead',
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
      event = { 'BufReadPost', 'CursorHold' },
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
          'lambdalisue/mr.vim',
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
