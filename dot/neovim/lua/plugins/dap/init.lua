local dap = require 'dap'

local stdpath = require('rc.utils').stdpath

local MASON = vim.fs.joinpath(stdpath.data, 'mason')
local WINDOWS = vim.fn.has 'win32' == 1

dap.adapters = {
  cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = vim.fs.joinpath(MASON, 'bin', 'OpenDebugAD7.cmd'),
    options = {
      detached = not WINDOWS,
    },
  },
  python = {
    type = 'executable',
    command = vim.fs.joinpath(MASON, 'packages', 'debugpy', 'venv', WINDOWS and 'Scripts' or 'bin', 'python'),
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
