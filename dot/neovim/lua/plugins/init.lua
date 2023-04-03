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
  local function notify(...)
    Config.notify()
    return require 'notify'(...)
  end
  vim.notify = notify
  print = notify
end

function Init.neotree()
  map('n', '<Space>e', '<Cmd>Neotree toggle=true source=filesystem<CR>')
end

function Init.ccc()
  map('n', '<Space>cp', '<Cmd>CccPick<CR>')
  map('n', '<Space>cc', '<Cmd>CccConvert<CR>')
  map('n', '<Space>ct', '<Cmd>CccHighlighterToggle<CR>')
end

function Init.telescope()
  map('n', '<Space>fs', '<Cmd>Telescope find_files<CR>')
  map('n', '<Space>fg', '<Cmd>Telescope live_grep<CR>')
  map('n', '<Space>fh', '<Cmd>Telescope mr mrw<CR>')
  map('n', '<Space>fl', '<Cmd>Telescope highlights<CR>')
end

require 'plugins.lazy'(Init, Config)
