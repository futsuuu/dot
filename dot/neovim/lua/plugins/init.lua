local m = vim.keymap.set

local build = require('plugins.build')
local config = require('plugins.config')
local utils = require('rc.utils')
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

function init.deck()
  m('n', '<Space>fs', '<Cmd>Deck files<CR>')
  m('n', '<Space>fh', '<Cmd>Deck mrw<CR>')
  m('n', '<Space>fg', '<Cmd>Deck grep<CR>')
end

function init.telescope()
  -- m('n', '<Space>fs', '<Cmd>Telescope find_files hidden=true<CR>')
  -- m('n', '<Space>fh', '<Cmd>Telescope mr mrw<CR>')
  -- m('n', '<Space>fg', '<Cmd>Telescope live_grep<CR>')
  m('n', '<Space>fl', '<Cmd>Telescope highlights<CR>')
end

function init.mr()
  vim.g['mr#mrw#predicates'] = {
    ---@param filename string
    function(filename)
      return filename:match('%.git[/\\]') == nil
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
  local gitsigns = require('gitsigns')
  m('n', '<Space>gr', function()
    gitsigns.reset_hunk()
  end)
  m('n', '<Space>ga', function()
    gitsigns.stage_hunk()
  end)
  m('n', ']g', function()
    gitsigns.nav_hunk('next')
  end)
  m('n', '[g', function()
    gitsigns.nav_hunk('prev')
  end)
  m('n', 'vih', function()
    gitsigns.select_hunk()
  end)
  m('n', '<Space>gA', function()
    gitsigns.stage_buffer()
  end)
  m('n', '<Space>gu', function()
    gitsigns.undo_stage_hunk()
  end)
  m('n', '<Space>gp', function()
    gitsigns.preview_hunk_inline()
  end)
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

require('plugins.lazy')(init, config, build)
