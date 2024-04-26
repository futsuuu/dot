local stdpath = require('rc.utils').stdpath

local M = {}

local cwd = vim.fn.getcwd
local data_path = vim.fs.joinpath(stdpath.data, 'cwd')

function M.save()
  local file = io.open(data_path, 'w')
  if file == nil then
    return
  end
  file:write(cwd())
  file:close()
end

function M.restore()
  local file = io.open(data_path, 'r')
  if not file then
    return
  end
  local path = file:read '*a'
  if vim.fn.isdirectory(path) == 1 then
    vim.api.nvim_set_current_dir(path)
  else
    M.save()
  end
  file:close()
end

if vim.fn.expand '~' == cwd() or vim.g.gui_running then
  M.restore()
else
  M.save()
end

vim.api.nvim_create_autocmd('DirChanged', {
  callback = M.save,
})

return M
