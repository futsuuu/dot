local ui = require 'rc.ui'

require('dapui').setup {
  icons = {
    expanded = ui.chevron.down,
    collapsed = ui.chevron.right,
  },
}

local sign = vim.fn.sign_define

sign('DapBreakpoint', { text = ' ', texthl = 'DapBreakpoint' })
sign('DapStopped', { text = ' ', texthl = 'DapStopped' })
