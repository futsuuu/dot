local m = vim.keymap.set

local config = require 'plugins.config'
local utils = require 'rc.utils'
local req = utils.lazy_require

local init = {}

function init.edge()
  vim.g.edge_disable_italic_comment = 1
end

function init.dressing()
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.select = function(...)
    config.dressing()
    return vim.ui.select(...)
  end
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.input = function(...)
    config.dressing()
    return vim.ui.input(...)
  end
end

function init.fidget()
  local function notify(...)
    config.fidget()
    return require('fidget').notify(...)
  end
  vim.notify = notify
end

function init.aerial()
  m('n', '<Space>a', '<Cmd>AerialToggle<CR>')
end

function init.oil()
  m('n', '<Space>e', '<Cmd>Oil<CR>')
end

function init.telescope()
  m('n', '<Space>fs', '<Cmd>Telescope find_files hidden=true<CR>')
  m('n', '<Space>fh', '<Cmd>Telescope mr mrw<CR>')
  m('n', '<Space>fg', '<Cmd>Telescope live_grep<CR>')
  m('n', '<Space>fl', '<Cmd>Telescope highlights<CR>')
end

function init.mr()
  vim.g['mr#mrw#predicates'] = {
    ---@param filename string
    function(filename)
      return filename:match '%.git[/\\]' == nil
    end,
  }
end

function init.dap()
  m('n', '<Space>dd', req('dapui').toggle)
  m('n', '<Space>db', req('dap').toggle_breakpoint)
end

function init.suda()
  vim.api.nvim_create_user_command('S', 'SudaWrite', {})
end

function init.skkeleton()
  m({ 'i', 'c' }, '<C-j>', '<Plug>(skkeleton-toggle)')
end

function init.gitsigns()
  m({ 'n', 'v' }, '<Space>gr', '<Cmd>Gitsigns reset_hunk<CR>')
  m('n', ']g', '<Cmd>Gitsigns next_hunk<CR>')
  m('n', '[g', '<Cmd>Gitsigns prev_hunk<CR>')
  m('n', 'vih', '<Cmd>Gitsigns select_hunk<CR>')
  m('n', '<Space>ga', '<Cmd>Gitsigns stage_hunk<CR>')
  m('n', '<Space>gu', '<Cmd>Gitsigns undo_stage_hunk<CR>')
  m('n', '<Space>gp', '<Cmd>Gitsigns preview_hunk_inline<CR>')
end

function init.bufdelete()
  m('n', '<Space>bd', '<Cmd>Bwipeout!<CR>')
end

function init.ccc()
  m('n', '<Space>cp', '<Cmd>CccPick<CR>')
  m('n', '<Space>cc', '<Cmd>CccConvert<CR>')
  m('n', '<Space>ct', '<Cmd>CccHighlighterToggle<CR>')
end

function init.overseer()
  m('n', '<Space>qr', '<Cmd>OverseerRun<CR>')
  m('n', '<Space>qt', '<Cmd>OverseerToggle<CR>')
end

require 'plugins.lazy'(init, config)
