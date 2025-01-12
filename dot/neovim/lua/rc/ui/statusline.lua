local opt = vim.opt

local hl = require('rc.highlight')

local M = {}

function M.hide()
  opt.statusline = "%{''}"
  opt.fillchars:append({
    stl = '─',
    stlnc = '─',
  })
  hl.set({ StatusLine = 'LineNr', StatusLineNC = 'StatusLine' })
end

return M
