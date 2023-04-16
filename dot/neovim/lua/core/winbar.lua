local utils = require 'core.utils'
local ui = require 'core.ui'

local M = {}

---@param bufnr number
---@param file string
function M.get_winbar(bufnr, file)
  file = file:gsub(vim.fn.getcwd(), '')
  file = file:gsub(vim.fn.expand '~', '~')

  local path = utils.split(file, '/\\')

  ---@type string
  local navic_info = require('nvim-navic').get_location(nil, bufnr)

  if navic_info ~= '' then
    table.insert(path, navic_info)
  end

  return ' ' .. utils.join(path, ui.winbar_sep)
end

vim.api.nvim_create_autocmd('BufRead', {
  pattern = '*',
  callback = function(ev)
    vim.opt_local.winbar = "%!v:lua.require'core.winbar'.get_winbar(" .. ev.buf .. ",'" .. ev.file .. "')"
  end,
})

return M
