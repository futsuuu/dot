local autocmd = vim.api.nvim_create_autocmd
local buffer = require 'string.buffer'

local stdpath = require('rc.utils').stdpath

local cwd = vim.fn.getcwd
local data_path = vim.fs.joinpath(stdpath.data, 'state')

local M = {}

---@class rc.State
---@field cwd string
---@field darkmode boolean
---@field colorscheme string
M.state = {}

function M.write()
  local file = io.open(data_path, 'w')
  if file == nil then
    return
  end
  file:write(buffer.new():encode(M.state):tostring())
  file:close()
end

function M.read()
  local file = io.open(data_path, 'r')
  if not file then
    M.state = {
      cwd = cwd(),
      darkmode = true,
      colorscheme = 'default',
    }
    M.write()
    return
  end
  ---@type rc.State
  ---@diagnostic disable-next-line: assign-type-mismatch
  M.state = buffer.new():set(file:read '*a'):decode()
  file:close()
end

function M.setup()
  M.read()

  if vim.uv.os_homedir() == cwd() or vim.g.gui_running then
    vim.api.nvim_set_current_dir(M.state.cwd)
  else
    M.state.cwd = cwd()
  end
  autocmd('DirChanged', {
    callback = function()
      M.state.cwd = cwd()
      M.write()
    end,
  })

  vim.o.background = M.state.darkmode and 'dark' or 'light'
  autocmd('OptionSet', {
    pattern = 'background',
    callback = function()
      M.state.darkmode = vim.o.background == 'dark'
      M.write()
    end,
  })

  pcall(vim.cmd.colorscheme, M.state.colorscheme)
  autocmd('ColorScheme', {
    callback = function()
      M.state.colorscheme = vim.g.colors_name
      M.write()
    end,
  })
end

return M
