local api = vim.api
local uv = vim.uv
local normalize = vim.fs.normalize

local ui = require 'core.ui'

local home = normalize(uv.os_homedir() or '')
local runtime = normalize(vim.env.VIMRUNTIME)

local M = {}

---@param bufnr number
---@return string
local function get_navic_info(bufnr)
  local status, navic = pcall(require, 'nvim-navic')
  if not status then
    return ''
  end

  return navic.get_location(nil, bufnr)
end

---@param bufnr number
---@return string
local function get_icon(bufnr)
  local status, devicons = pcall(require, 'nvim-web-devicons')
  if not status then
    return ''
  end

  local filetype = vim.fn.getbufvar(bufnr, '&filetype')
  ---@type string, string
  local icon, hl = devicons.get_icon_by_filetype(filetype)
  return '%#' .. hl .. '#' .. icon .. '%* '
end

---@param bufnr number
---@return string
function M.get_winbar(bufnr)
  local cwd = normalize(uv.cwd() or '')
  local file = normalize(api.nvim_buf_get_name(bufnr))
  file = file:replace(cwd, '')
  file = file:replace(runtime, '')
  file = file:replace(home, '~')

  local path = file:split '/'

  local file_name = table.remove(path)
  table.insert(path, get_icon(bufnr) .. file_name)

  local navic_info = get_navic_info(bufnr)

  local winbar = ' '
  winbar = winbar .. ui.winbar_sep.path:join(path)

  if navic_info ~= '' then
    winbar = winbar .. ui.winbar_sep.context
    winbar = winbar .. navic_info
  end

  return winbar
end

api.nvim_set_hl(0, 'WinBar', { link = 'WinBarNC' })
api.nvim_create_autocmd('BufRead', {
  pattern = '*',
  callback = function(ev)
    if not uv.fs_stat(ev.file) then
      return
    end
    vim.opt_local.winbar = "%!v:lua.require'core.winbar'.get_winbar(" .. ev.buf .. ')'
  end,
})

return M
