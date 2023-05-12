---@diagnostic disable: undefined-field

---@param init Plugins.Init
---@param config Plugins.Config
return function(init, config)
  local plugins = {}

  local function group(flag_name)
    return function(plugin_list)
      for _, plugin in ipairs(plugin_list) do
        plugin.cond = _G.plugin_flags[flag_name]
        table.insert(plugins, plugin)
      end
    end
  end

  group 'alpha' {
    {
      'goolord/alpha-nvim',
      config = config.alpha,
      event = 'VimEnter',
    },
  }

  group 'cmp' {
    {
      'hrsh7th/nvim-cmp',
      config = config.cmp,
    },
    { 'hrsh7th/cmp-buffer', event = 'InsertEnter' },
    { 'hrsh7th/cmp-nvim-lsp', event = 'InsertEnter' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help', event = 'InsertEnter' },
    { 'hrsh7th/cmp-path', event = { 'InsertEnter', 'CmdlineEnter' } },
    { 'hrsh7th/cmp-cmdline', event = 'CmdlineEnter' },
    {
      'saadparwaiz1/cmp_luasnip',
      event = 'InsertEnter',
      dependencies = {
        {
          'L3MON4D3/LuaSnip',
          version = '*',
          dependencies = {
            'rafamadriz/friendly-snippets',
          },
          config = config.luasnip,
        },
      },
    },
  }

  group 'nvim_lsp' {
    {
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
        {
          'j-hui/fidget.nvim',
          config = config.fidget,
        },
        {
          'SmiteshP/nvim-navic',
          config = config.navic,
          event = 'BufReadPre',
        },
      },
    },
    {
      'aznhe21/actions-preview.nvim',
      config = config.actions_preview,
    },

  group 'rust' {
    {
      'saecki/crates.nvim',
      version = '*',
      event = 'BufReadPre Cargo.toml',
      config = config.crates,
    },
  }

  group 'telescope' {
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
          event = 'BufReadPre',
        },
      },
    },
  }

  group 'treesitter' {
    {
      'nvim-treesitter/nvim-treesitter',
      module = false,
      build = ':TSUpdate',
      event = 'BufRead',
      config = config.treesitter,
      dependencies = {
        'mrjones2014/nvim-ts-rainbow',
        'windwp/nvim-ts-autotag',
      },
    },
  }

  group 'foldcolumn' {
    {
      'luukvbaal/statuscol.nvim',
      event = { 'BufRead', 'TabNew' },
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
  }

  group 'main' {
    { 'nvim-lua/plenary.nvim' },
    {
      'nvim-tree/nvim-web-devicons',
      config = config.devicons,
    },
    { 'MunifTanjim/nui.nvim' },

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

    -- buffer
    {
      'akinsho/bufferline.nvim',
      version = '*',
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
      'jose-elias-alvarez/null-ls.nvim',
      event = 'BufReadPost',
      config = config.null_ls,
    },

    {
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      cmd = 'Neotree',
      init = init.neotree,
      config = config.neotree,
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
      'lambdalisue/suda.vim',
      cmd = {
        'SudaRead',
        'SudaWrite',
      },
      enabled = vim.fn.executable 'sudo' == 1,
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

  local ui = require 'core.ui'
  require('lazy').setup(plugins, {
    defaults = {
      lazy = true,
    },
    concurrency = 10,
    ui = {
      border = 'rounded',
      icons = {
        loaded = ui.status.check,
        not_loaded = ui.status.close,
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
