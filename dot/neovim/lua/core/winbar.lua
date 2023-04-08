local M = {}

---@param bufnr number
---@param file string
function M.get_winbar(bufnr, file)
  local _s = '❯'
  local i_s = _s .. ' '
  local sep = ' ' .. _s .. ' '

  local navic_info = require('nvim-navic').get_location(nil, bufnr)

  local path = file:gsub(vim.fn.getcwd(), ''):gsub(vim.fn.expand '~', '~'):gsub('[/\\]', ' ❯ '):gsub('^ +' .. i_s, '')
  return ' ' .. path .. ((navic_info ~= '') and (sep .. navic_info) or '')
end

vim.api.nvim_create_autocmd('BufRead', {
  pattern = '*',
  callback = function(ev)
    vim.opt_local.winbar = "%!v:lua.require'core.winbar'.get_winbar(" .. ev.buf .. ",'" .. ev.file .. "')"
  end,
})

return M
