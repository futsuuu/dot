---@class Plugins.Init
local Init = {}
local Config = require 'plugins.config'

local utils = require 'utils'
local req = utils.lazy_require
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

function Init.ddu()
  m('n', '<Space>fr', '<Cmd>Ddu -name=ghq<CR>')
  m('n', '<Space>fs', '<Cmd>Ddu file_rec<CR>')
  m('n', '<Space>fh', '<Cmd>Ddu mr<CR>')
  m('n', '<Space>fg', '<Cmd>Ddu -name=rg-live<CR>')
  m('n', '<Space>fl', '<Cmd>Ddu highlight<CR>')
  m('n', '<Space>fn', '<Cmd>Ddu -name=notify<CR>')
  m('n', '<Space>la', '<Cmd>Ddu -name=code-action<CR>')
  m('n', '<Space>ld', '<Cmd>Ddu -name=definition<CR>')
  m('n', '<Space>lr', '<Cmd>Ddu -name=references<CR>')
end

function Init.mr()
  vim.g['mr#mrw#predicates'] = {
    ---@param filename string
    function(filename)
      return filename:match '%.git[/\\]' == nil
    end,
  }
end

function Init.dap()
  m('n', '<Space>dd', req('dapui').toggle)
  m('n', '<Space>db', req('dap').toggle_breakpoint)
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
  m('n', 'vih', '<Cmd>Gitsigns select_hunk<CR>')
  m('n', '<Space>ga', '<Cmd>Gitsigns stage_hunk<CR>')
  m('n', '<Space>gu', '<Cmd>Gitsigns undo_stage_hunk<CR>')
  m('n', '<Space>gp', '<Cmd>Gitsigns preview_hunk_inline<CR>')
end

function Init.bufdelete()
  m('n', '<Space>bd', '<Cmd>Bwipeout!<CR>')
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

require 'plugins.lazy'(Init, Config)

vim.cmd.colorscheme(_G.config_flags.colorscheme)
