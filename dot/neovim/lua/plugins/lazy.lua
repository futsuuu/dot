---@diagnostic disable: undefined-field

local flags = _G.config_flags

---@param init Plugins.Init
---@param config Plugins.Config
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
    { 'uga-rosa/cmp-skkeleton', event = 'User skkeleton-enable-pre' },
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

  group 'ddu' {
    {
      'Shougo/ddu.vim',
      dependencies = {
        'Shougo/ddu-ui-ff',
        'Shougo/ddu-ui-filer',
        'Shougo/ddu-source-file',
        'Shougo/ddu-source-file_rec',
        'Shougo/ddu-source-line',
        'matsui54/ddu-source-highlight',
        'shun/ddu-source-rg',
        'shun/ddu-source-buffer',
        '4513ECHO/ddu-source-ghq',
        '4513ECHO/ddu-source-colorscheme',
        'uga-rosa/ddu-source-lsp',
        'yuki-yano/ddu-source-nvim-notify',
        {
          'kuuote/ddu-source-mr',
          dependencies = {
            {
              'lambdalisue/mr.vim',
              init = init.mr,
              event = 'BufReadPre',
            },
          },
        },
        'yuki-yano/ddu-filter-fzf',
        'Shougo/ddu-filter-matcher_relative',
        'uga-rosa/ddu-filter-converter_devicon',
        'Shougo/ddu-kind-file',
        'ryota2357/ddu-column-icon_filename',
        'Shougo/ddu-commands.vim',
      },
      init = init.ddu,
      config = config.ddu,
      event = 'VeryLazy',
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

  group 'statuscolumn' {
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
    {
      'lewis6991/gitsigns.nvim',
      config = config.gitsigns,
      init = init.gitsigns,
      cmd = 'Gitsigns',
      event = 'BufRead',
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
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v3.x',
      cmd = 'Neotree',
      init = init.neotree,
      config = config.neotree,
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
      enabled = vim.fn.executable 'sudo' == 1,
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
    dev = {
      path = '~/dev/github.com/futsuuu',
      patterns = { 'futsuuu' },
      fallback = true,
    },
    concurrency = 10,
    install = {
      colorscheme = { flags.colorscheme, 'habamax' },
    },
    ui = {
      border = 'rounded',
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
