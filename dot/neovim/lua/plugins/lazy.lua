local flags = _G.config_flags

return function(init, config)
  local plugins = {}

  local function group(flag_name)
    return function(plugin_list)
      for _, plugin in ipairs(plugin_list) do
        local flag = flags[flag_name]
        plugin.cond = type(flag) == 'nil' and false or flag
        table.insert(plugins, plugin)
      end
    end
  end

  group 'colorscheme' {
    { 'sainnhe/edge' },
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
          'lambdalisue/mr.vim',
          init = init.mr,
          event = 'BufReadPre',
        },
      },
    },
    { 'nvim-telescope/telescope-file-browser.nvim' },
    { 'natecraddock/telescope-zf-native.nvim' },
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
    { 'hrsh7th/cmp-vsnip', event = 'InsertEnter', cond = flags.vsnip },
  }

  group 'vsnip' {
    {
      'hrsh7th/vim-vsnip',
      version = '*',
      dependencies = {
        'hrsh7th/vim-vsnip-integ',
        'rafamadriz/friendly-snippets',
      },
      event = 'InsertEnter',
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
          'b0o/schemastore.nvim',
        },
        {
          'j-hui/fidget.nvim',
          tag = 'legacy',
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
      'stevearc/aerial.nvim',
      cmd = 'AerialToggle',
      init = init.aerial,
      config = config.aerial,
    },
    {
      dir = '~/dev/github.com/zbirenbaum/neodim',
      event = 'LspAttach',
      config = config.neodim,
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
  }

  group 'null_ls' {
    {
      'jose-elias-alvarez/null-ls.nvim',
      event = 'BufReadPost',
      config = config.null_ls,
    },
  }

  group 'nvim_dap' {
    {
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
  }

  group 'rust' {
    {
      'saecki/crates.nvim',
      event = 'BufReadPre Cargo.toml',
      config = config.crates,
    },
  }

  group 'treesitter' {
    {
      'nvim-treesitter/nvim-treesitter',
      module = false,
      cmd = { 'TSUpdate', 'TSInstall', 'TSInstallInfo', 'TSUninstall', 'TSEnable' },
      build = ':TSUpdate',
      event = 'BufRead',
      config = config.treesitter,
    },
  }

  group 'skkeleton' {
    {
      'vim-skk/skkeleton',
      keys = { { '<C-j>', '<Plug>(skkeleton-enable)', mode = { 'i', 'c' } } },
      event = 'CursorHold',
      config = function()
        require('denops-lazy').load 'skkeleton'
        config.skkeleton()
      end,
    },
  }

  group 'denops' {
    {
      'vim-denops/denops.vim',
      event = 'VeryLazy',
    },
    {
      'vim-denops/denops-shared-server.vim',
      build = {
        ':let g:denops#deno = "deno"',
        ':let g:denops_server_addr = "127.0.0.1:32123"',
        ':call denops_shared_server#install()',
      },
    },
    { 'yuki-yano/denops-lazy.nvim' },
  }

  group 'decoration' {
    {
      'folke/todo-comments.nvim',
      event = 'BufRead',
      config = config.todo_comments,
    },
    {
      'lukas-reineke/indent-blankline.nvim',
      event = 'CursorMoved',
      config = config.blankline,
    },
    {
      'lewis6991/satellite.nvim',
      event = 'BufRead',
      config = config.satellite,
    },
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
      'LumaKernel/nvim-visual-eof.lua',
      config = config.visual_eof,
      event = 'BufRead',
    },
    {
      'stevearc/dressing.nvim',
      init = init.dressing,
    },
    {
      'rcarriga/nvim-notify',
      cmd = 'Notifications',
      init = init.notify,
    },
  }

  group 'buffer' {
    {
      'akinsho/bufferline.nvim',
      version = '*',
      event = { 'BufRead', 'TermOpen', 'TabNew' },
      config = config.bufferline,
    },
    {
      'backdround/tabscope.nvim',
      event = 'WinEnter',
      config = config.tabscope,
    },
    {
      'famiu/bufdelete.nvim',
      cmd = { 'Bdelete', 'Bwipeout' },
      init = init.bufdelete,
    },
  }

  group 'on_open' {
    {
      'ethanholz/nvim-lastplace',
      event = 'BufReadPre',
      config = config.lastplace,
    },
  }

  group 'main' {
    { 'nvim-lua/plenary.nvim' },
    {
      'nvim-tree/nvim-web-devicons',
      config = config.devicons,
    },
    { 'MunifTanjim/nui.nvim' },

    {
      'elkowar/yuck.vim',
      event = 'VeryLazy',
    },

    {
      'hrsh7th/nvim-insx',
      event = { 'InsertEnter', 'CmdlineEnter' },
      config = config.insx,
    },
    {
      'kylechui/nvim-surround',
      version = '*',
      event = 'CursorMoved',
      config = config.nvim_surround,
    },

    {
      'NeogitOrg/neogit',
      cmd = 'Neogit',
      config = config.neogit,
    },
    {
      'lewis6991/gitsigns.nvim',
      config = config.gitsigns,
      init = init.gitsigns,
      cmd = 'Gitsigns',
      event = 'BufRead',
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
