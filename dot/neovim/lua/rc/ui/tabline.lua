local hl = require 'rc.highlight'
local line = require 'rc.ui.line'
local ui = require 'rc.ui'

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
          hl.ensure('TabLineOverseer' .. status, function()
            return hl.get('Overseer' .. status):extend 'TabLineFill'
          end).name
        )
        .. ' '
    end
  end

  return result
end

---@param buf buffer
---@return boolean
local function is_modified(buf)
  return vim.api.nvim_get_option_value('modified', { buf = buf })
end

---@param buffer buffer
---@param is_selected boolean
---@return string
local function buffer_info(buffer, is_selected)
  local bufname = vim.api.nvim_buf_get_name(buffer)
  local hl_suffix = is_selected and 'Sel' or ''
  local hl_group = 'TabLine' .. hl_suffix
  local t = ''

  local sep_hl = hl.ensure('TabLineSep', function()
    return hl.get('TabLineFill'):extend(hl.get('Normal'):reverse():clear_bg())
  end)

  if is_selected then
    t = t .. line.with_hl('', sep_hl.name)
  end
  t = t .. line.with_hl((is_selected and '  ' or ' '), hl_group)
  local icon = require('clico').get {
    path = bufname,
    ft = vim.api.nvim_get_option_value('filetype', { buf = buffer }),
  }
  t = t
    .. line.with_hl(
      icon.icon,
      hl.ensure('TabLine' .. icon.hl .. hl_suffix, function()
        return hl.get(icon.hl):extend(hl_group)
      end).name
    )
  t = t .. line.with_hl(' ' .. vim.fs.basename(bufname) .. ' ', hl_group)

  if is_modified(buffer) then
    t = t
      .. line.with_hl(
        '' .. (is_selected and '' or ' '),
        hl.ensure('TabLineModified' .. hl_suffix, function()
          return hl.get('Function'):extend(hl_group)
        end).name
      )
  else
    t = t .. line.with_hl(' ', hl_group)
  end

  t = t .. line.with_hl(is_selected and ' ' or '', hl_group)
  if is_selected then
    t = t .. line.with_hl('', sep_hl.name)
  end

  return t
end

---@return string
local function get_tabline()
  local current_buf = vim.api.nvim_get_current_buf()
  local tabline = vim
    .iter(vim.api.nvim_list_bufs())
    :filter(function(buf)
      return vim.api.nvim_buf_is_loaded(buf) and vim.fn.buflisted(buf) == 1 and vim.api.nvim_buf_get_name(buf) ~= ''
    end)
    :map(function(buf)
      return buffer_info(buf, buf == current_buf)
    end)
    :join ''

  tabline = tabline .. '%=' .. overseer_info()
  return tabline
end

local M = {}

function M.setup()
  hl.set { TabLine = 'TabLineFill', TabLineFill = 'DiffChange', TabLineSel = 'Normal' }
  vim.opt.showtabline = 2
  vim.opt.tabline = line.as_opt(get_tabline)
  vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
    command = 'redrawtabline',
  })
end

return M
