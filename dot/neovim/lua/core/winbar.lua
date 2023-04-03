local M = {}

function M.get_winbar()
  local _s = '❯'
  local i_s = _s .. ' '
  local sep = ' ' .. _s .. ' '

  local navic_info = require('nvim-navic').get_location()

  local path = vim.fn
    .expand('%s')
    :gsub(vim.fn.getcwd(), '')
    :gsub(vim.fn.expand '~', '~')
    :gsub('[/\\]', ' ❯ ')
    :gsub('^ +' .. i_s, '')
  return ' ' .. path .. ((navic_info ~= '') and (sep .. navic_info) or '')
end

vim.api.nvim_create_autocmd('BufRead', {
  pattern = '*',
  callback = function()
    vim.opt_local.winbar = "%!v:lua.require'core.winbar'.get_winbar()"
  end,
})

return M
