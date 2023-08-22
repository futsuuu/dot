vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.nu',
  callback = function()
    vim.opt_local.filetype = 'config'
  end,
})
