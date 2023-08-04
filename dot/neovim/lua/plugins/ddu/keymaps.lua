local ddu = require('utils').call 'ddu'
local au = vim.api.nvim_create_autocmd
local optl = vim.opt_local

local function m(...)
  local args = { ... }
  if type(args[4]) ~= 'table' then
    table.insert(args, {})
  end
  args[4] = vim.tbl_extend('keep', args[4], { buffer = true, silent = true })
  vim.keymap.set(unpack(args))
end

---@param fn function
local function in_normal(fn)
  return function()
    vim.cmd.stopinsert()
    vim.schedule(fn)
  end
end

au('FileType', {
  pattern = 'ddu-ff',
  callback = function()
    optl.cursorline = true
    optl.statuscolumn = ''
    optl.signcolumn = 'no'
    m('n', '<CR>', ddu.ui.ff.do_action._fn 'itemAction')
    m('n', 'i', ddu.ui.ff.do_action._fn 'openFilterWindow')
    m('n', 'q', ddu.ui.ff.do_action._fn 'quit')
  end,
})

au('FileType', {
  pattern = 'ddu-ff-filter',
  callback = function()
    optl.statuscolumn = ' %#rainbowcol6#❱%#rainbowcol7#❱%#rainbowcol1#❱ %*'
    vim.defer_fn(function()
      optl.cursorline = false
    end, 300)
    vim.schedule(function()
      optl.cursorline = false
    end)
    m(
      { 'i', 'n' },
      '<CR>',
      in_normal(function()
        if ddu.ui.get_item().kind == 'file' then
          ddu.ui.do_action('itemAction', { name = 'open', params = { command = 'edit' } })
        else
          ddu.ui.do_action 'itemAction'
        end
      end)
    )
    m({ 'i', 'n' }, '<C-c>', in_normal(ddu.ui.do_action._fn 'quit'))
    m('i', '<C-j>', ddu.ui.ff.do_action._fn 'cursorNext')
    m('i', '<C-k>', ddu.ui.ff.do_action._fn 'cursorPrevious')
    m('i', '<Esc>', in_normal(ddu.ui.ff.do_action._fn 'closeFilterWindow'))
    m('n', 'j', ddu.ui.ff.do_action._fn 'cursorNext')
    m('n', 'k', ddu.ui.ff.do_action._fn 'cursorPrevious')
    m('i', '<C-d>', ddu.ui.do_action._fn('previewExecute', { command = [[execute "normal! \<C-d>"]] }))
    m('i', '<C-u>', ddu.ui.do_action._fn('previewExecute', { command = [[execute "normal! \<C-u>"]] }))
  end,
})

au('FileType', {
  pattern = 'ddu-filer',
  callback = function()
    m('n', '<CR>', function()
      if ddu.ui.get_item().isTree then
        ddu.ui.do_action('expandItem', { mode = 'toggle' })
      else
        ddu.ui.do_action('itemAction', { name = 'open' })
      end
    end)
    m('n', '.', ddu.ui.do_action._fn('itemAction', { name = 'cd' }))
    m('n', '<BS>', ddu.ui.do_action._fn('itemAction', { name = 'narrow', params = { path = '..' } }))
    m('n', 'q', ddu.ui.do_action._fn 'quit')
  end,
})
