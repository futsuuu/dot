return {
  name = 'run current file',
  builder = function()
    local expand = vim.fn.expand
    return {
      cmd = { 'python' },
      args = { expand('%:p') },
      name = 'run ' .. expand('%'),
      components = { 'default' },
    }
  end,
  condition = {
    filetype = { 'python' },
  },
}
