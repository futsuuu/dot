local api = vim.api

local line = require 'rc.ui.line'
local ui = require 'rc.ui'
local hl = require 'rc.highlight'

---@return buffer[]
local function get_buffers()
  return vim
    .iter(api.nvim_list_bufs())
    :filter(function(buf)
      return api.nvim_buf_is_loaded(buf) and vim.fn.buflisted(buf) == 1 and api.nvim_buf_get_name(buf) ~= ''
    end)
    :totable()
end

---@return string
local function overseer_info()
  local result = ''
  if not package.loaded.overseer then
    return result
  end

  local tasks = require('overseer.task_list').list_tasks { unique = true }
  local tasks_by_status = require('overseer.util').tbl_group_by(tasks, 'status')

  for status, symbol in pairs(ui.status) do
    status = status:upper()
    local task = tasks_by_status[status]
    if task then
      result = result .. line.with_hl(symbol .. ' ' .. #task .. ' ', 'Overseer' .. status)
    end
  end

  return result
end

---@return string
local function get_tabline()
  local current_buf = api.nvim_get_current_buf()
  local tabline = ''
  for _, buf in ipairs(get_buffers()) do
    local hl_group = 'TabLine'
    if buf == current_buf then
      hl_group = 'TabLineSel'
    end
    tabline = tabline .. line.with_hl(' ' .. vim.fs.basename(api.nvim_buf_get_name(buf)) .. ' ', hl_group)
  end
  tabline = tabline .. '%=' .. overseer_info()
  return tabline
end

local M = {}

function M.setup()
  hl { TabLine = 'WinBar', TabLineFill = 'Normal', TabLineSel = 'DiffChange' }
  vim.opt.showtabline = 2
  vim.opt.tabline = line.as_opt(get_tabline)
  api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
    command = 'redrawtabline',
  })
end

return M
