local api = vim.api

local line = require 'rc.ui.line'
local ui = require 'rc.ui'
local hl = require 'rc.highlight'

---@param new string
---@param base string
---@param background string
---@return string
local function merge_hl(new, base, background)
  if vim.tbl_isempty(api.nvim_get_hl(0, { name = new })) then
    api.nvim_set_hl(
      0,
      new,
      vim.tbl_extend(
        'keep',
        api.nvim_get_hl(0, { name = base, link = false }),
        api.nvim_get_hl(0, { name = background, link = false })
      )
    )
  end
  return new
end

---@return buffer[]
local function list_buffers()
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
      result = result
        .. line.with_hl(
          symbol .. ' ' .. #task,
          merge_hl('TabLineOverseer' .. status, 'Overseer' .. status, 'TabLineFill')
        )
        .. ' '
    end
  end

  return result
end

---@param buf buffer
---@return boolean
local function is_modified(buf)
  return api.nvim_get_option_value('modified', { buf = buf })
end

---@return string
local function get_tabline()
  local current_buf = api.nvim_get_current_buf()
  local tabline = ''

  for _, buf in ipairs(list_buffers()) do
    local name = api.nvim_buf_get_name(buf)
    local is_selected = buf == current_buf
    local hl_suffix = is_selected and 'Sel' or ''
    local hl_group = 'TabLine' .. hl_suffix

    local t = line.with_hl('  ', hl_group)
    local icon = require('clico').get {
      path = name,
      ft = api.nvim_get_option_value('filetype', { buf = buf }),
    }
    t = t .. line.with_hl(icon.icon, merge_hl('TabLine' .. icon.hl .. hl_suffix, icon.hl, hl_group))
    t = t .. line.with_hl(' ' .. vim.fs.basename(name) .. ' ', hl_group)
    if is_modified(buf) then
      t = t .. line.with_hl('', merge_hl('TabLineModified' .. hl_suffix, 'Function', hl_group))
    else
      t = t .. line.with_hl(' ', hl_group)
    end
    t = t .. line.with_hl(' ', hl_group)

    tabline = tabline .. t
  end

  tabline = tabline .. '%=' .. overseer_info()
  return tabline
end

local M = {}

function M.setup()
  hl { TabLine = 'TabLineFill', TabLineFill = 'DiffChange', TabLineSel = 'Normal' }
  vim.opt.showtabline = 2
  vim.opt.tabline = line.as_opt(get_tabline)
  api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
    command = 'redrawtabline',
  })
end

return M
