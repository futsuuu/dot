local devicons = require 'nvim-web-devicons'

local ui = require 'core.ui'

local M = {}

---@param bufnr number
---@param file string
function M.get_winbar(bufnr, file)
  file = file:gsub(vim.fn.getcwd(), '')
  file = file:gsub(vim.fn.expand '~', '~')

  local path = file:split '/\\'

  local filetype = vim.fn.getbufvar(bufnr, '&filetype')
  ---@type string, string
  local icon, hl = devicons.get_icon_by_filetype(filetype)
  local highlighted_icon = '%#' .. hl .. '#' .. icon .. '%* '

  local file_name = table.remove(path)
  table.insert(path, highlighted_icon .. file_name)

  ---@type string
  local navic_info = require('nvim-navic').get_location(nil, bufnr)

  if navic_info ~= '' then
    table.insert(path, navic_info)
  end

  return ' ' .. ui.winbar_sep:join(path)
end

vim.api.nvim_create_autocmd('BufRead', {
  pattern = '*',
  callback = function(ev)
    vim.opt_local.winbar = "%!v:lua.require'core.winbar'.get_winbar(" .. ev.buf .. ",'" .. ev.file .. "')"
  end,
})

return M
