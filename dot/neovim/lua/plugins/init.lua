---@class Plugins.Init
local Init = {}
local Config = require 'plugins.config'

local m = vim.keymap.set

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
end

function Init.aerial()
  m('n', '<Space>a', '<Cmd>AerialToggle<CR>')
end

function Init.suda()
  vim.api.nvim_create_user_command('S', 'SudaWrite', {})
end

function Init.neotree()
  m('n', '<Space>e', '<Cmd>Neotree toggle=true source=filesystem<CR>')
end

function Init.gitsigns()
  m({ 'n', 'v' }, '<Space>gr', '<Cmd>Gitsigns reset_hunk<CR>')
  m('n', ']g', '<Cmd>Gitsigns next_hunk<CR>')
  m('n', '[g', '<Cmd>Gitsigns prev_hunk<CR>')
  m('n', '<Space>gp', '<Cmd>Gitsigns preview_hunk_inline<CR>')
end

function Init.bufdelete()
  m('n', '<Space>bd', function()
    if vim.fn.expand('%s'):match '^term://.*' then
      return '<Cmd>Bdelete!<CR>'
    else
      return '<Cmd>Bdelete<CR>'
    end
  end, { expr = true })
end

function Init.ccc()
  m('n', '<Space>cp', '<Cmd>CccPick<CR>')
  m('n', '<Space>cc', '<Cmd>CccConvert<CR>')
  m('n', '<Space>ct', '<Cmd>CccHighlighterToggle<CR>')
end

function Init.overseer()
  m('n', '<Space>qr', '<Cmd>OverseerRun<CR>')
  m('n', '<Space>qt', '<Cmd>OverseerToggle<CR>')
end

function Init.action_preview()
  m('n', '<Space>ca', require('actions-preview').code_actions)
end

function Init.telescope()
  m('n', '<Space>fs', '<Cmd>Telescope find_files<CR>')
  m('n', '<Space>fg', '<Cmd>Telescope live_grep<CR>')
  m('n', '<Space>fh', '<Cmd>Telescope mr mrw<CR>')
  m('n', '<Space>fl', '<Cmd>Telescope highlights<CR>')
end

require 'plugins.lazy'(Init, Config)

vim.cmd.colorscheme(_G.plugin_flags.colorscheme)
