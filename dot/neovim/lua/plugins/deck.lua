local deck = require('deck')

local ignore_globs = { '**/.git/**' }

deck.register_start_preset('files', function()
  deck.start({
    require('deck.builtin.source.files')({
      root_dir = assert(vim.uv.cwd()),
      ignore_globs = ignore_globs,
    }),
  })
end)

deck.register_start_preset('mrw', function()
  deck.start({
    name = 'mrw',
    execute = function(cx)
      for _, v in ipairs(require('rc.utils').fn.mr.mrw.list()) do
        cx.item({
          display_text = v,
          data = {
            filename = v,
          },
        })
      end
      cx.done()
    end,
    actions = {
      deck.alias_action('default', 'open'),
    },
  })
end)

deck.register_start_preset('buffers', function()
  deck.start({
    require('deck.builtin.source.buffers')(),
  })
end)

deck.register_start_preset('lines', function()
  deck.start({
    require('deck.builtin.source.lines')(),
  })
end)

deck.register_start_preset('grep', function()
  local pattern = vim.fn.input('grep: ')
  if #pattern == 0 then
    return vim.notify('Canceled', vim.log.levels.INFO)
  end
  deck.start(
    require('deck.builtin.source.grep')({
      root_dir = assert(vim.uv.cwd()),
      ignore_globs = ignore_globs,
    }),
    {
      query = pattern .. '  ',
    }
  )
end)

deck.register_start_preset('git', function()
  deck.start(require('deck.builtin.source.git')({
    cwd = assert(vim.uv.cwd()),
  }))
end)

vim.api.nvim_create_autocmd('User', {
  pattern = 'DeckStart',
  callback = function(e)
    local cx = e.data.ctx

    cx.keymap('n', 'o', deck.action_mapping('choose_action'))
    cx.keymap('n', 'i', deck.action_mapping('prompt'))
    cx.keymap('n', 'p', deck.action_mapping('toggle_preview_mode'))
    cx.keymap('n', '<C-r>', deck.action_mapping('refresh'))
    cx.keymap({ 'c', 'n' }, '<Tab>', deck.action_mapping('toggle_select'))
    cx.keymap({ 'c', 'n' }, '<C-d>', deck.action_mapping('scroll_preview_down'))
    cx.keymap({ 'c', 'n' }, '<C-u>', deck.action_mapping('scroll_preview_up'))
    cx.keymap('c', '<C-n>', function()
      cx.set_cursor(cx.get_cursor() + 1)
    end)
    cx.keymap('c', '<C-p>', function()
      cx.set_cursor(cx.get_cursor() - 1)
    end)

    cx.keymap('n', '<CR>', deck.action_mapping('default'))
    cx.keymap('c', '<CR>', function()
      vim.api.nvim_feedkeys(vim.keycode('<Esc>'), 'n', true)
      vim.schedule(function()
        cx.do_action('default')
      end)
    end)

    cx.keymap('n', '<Esc>', cx.hide)
    cx.keymap('n', '<C-c>', cx.hide)
    cx.keymap('c', '<C-c>', function()
      vim.api.nvim_feedkeys(vim.keycode('<Esc>'), 'n', true)
      vim.schedule(cx.hide)
    end)

    cx.set_preview_mode(true)
    cx.prompt()
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'DeckShow',
  callback = function()
    vim.wo.cursorline = true
    vim.o.signcolumn = 'yes:1'
    vim.o.statuscolumn = '%=%s'

    if vim.o.cmdheight == 0 then
      vim.o.cmdheight = 1
      vim.api.nvim_create_autocmd('User', {
        once = true,
        pattern = 'DeckHide',
        callback = function()
          vim.o.cmdheight = 0
        end,
      })
    end
  end,
})
