---@class Plugins.Init
local Init = {}
local Config = require 'plugins.config'

local map = vim.keymap.set

function Init.dressing()
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.select = function(...)
    Config.dressing()
    return vim.ui.select(...)
  end
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.input = function(...)
    Config.dressing()
    return vim.ui.input(...)
  end
end

function Init.notify()
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.notify = function(...)
    Config.notify()
    return require 'notify'(...)
  end
end

function Init.neotree()
  map('n', '<Space>e', '<Cmd>Neotree toggle=true source=filesystem<CR>')
end

function Init.telescope()
  map('n', '<Space>fs', '<Cmd>Telescope find_files<CR>')
  map('n', '<Space>fg', '<Cmd>Telescope live_grep<CR>')
  map('n', '<Space>fh', function()
    local pickers = require 'telescope.pickers'
    local make_entry = require 'telescope.make_entry'
    local finders = require 'telescope.finders'
    local conf = require('telescope.config').values

    local mru = function(opts)
      opts = opts or {}
      pickers
        .new(opts, {
          prompt_title = 'MRU',
          finder = finders.new_table {
            results = vim.fn['mr#mru#list'](),
            entry_maker = opts.entry_maker or make_entry.gen_from_file(opts),
          },
          sorter = conf.file_sorter(opts),
          previewer = conf.file_previewer(opts),
        })
        :find()
    end

    mru()
  end)
end

require 'plugins.lazy'(Init, Config)
