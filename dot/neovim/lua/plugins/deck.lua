local deck = require('deck')

require('deck.easy').setup()

vim.api.nvim_create_autocmd('User', {
  pattern = 'DeckStart',
  callback = function(e)
    local cx = e.data.ctx

    cx.keymap('n', 'o', deck.action_mapping('choose_action'))
    cx.keymap('n', '<C-r>', deck.action_mapping('refresh'))
    cx.keymap('n', 'i', deck.action_mapping('prompt'))
    cx.keymap('n', '<Tab>', deck.action_mapping('toggle_select'))
    cx.keymap('n', 'p', deck.action_mapping('toggle_preview_mode'))
    cx.keymap('n', '<CR>', deck.action_mapping('default'))
    cx.keymap('c', '<C-n>', function()
      cx.set_cursor(cx.get_cursor() + 1)
    end)
    cx.keymap('c', '<C-p>', function()
      cx.set_cursor(cx.get_cursor() - 1)
    end)

    -- cx.prompt()
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'DeckShow',
  callback = function()
    vim.wo.cursorline = true

    if vim.o.laststatus == 0 then
      vim.o.laststatus = 3
      vim.api.nvim_create_autocmd('User', {
        once = true,
        pattern = 'DeckHide',
        callback = function()
          vim.o.laststatus = 0
        end,
      })
    end
  end,
})
