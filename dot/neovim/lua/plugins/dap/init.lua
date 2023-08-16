local dap = require 'dap'

local is_win = vim.fn.has 'win32' == 1
local mason = vim.fn.stdpath 'data' .. '/mason/'

dap.adapters = {
  cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = mason .. 'bin/OpenDebugAD7.cmd',
    options = {
      detached = not is_win,
    },
  },
  python = {
    type = 'executable',
    command = mason .. 'packages/debugpy/venv/' .. (is_win and 'Scripts' or 'bin') .. 'python',
    args = { '-m', 'debugpy.adapter' },
  },
}

dap.configurations = {
  rust = {
    {
      name = 'Launch file',
      type = 'cppdbg',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopAtEntry = true,
    },
  },
  python = {
    {
      name = 'Launch file',
      type = 'python',
      request = 'launch',
      program = '${file}',
      pythonPath = 'python',
    },
  },
}
