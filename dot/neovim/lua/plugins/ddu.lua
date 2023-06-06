local au = vim.api.nvim_create_autocmd

local ddu = require('utils').call 'ddu'

ddu.custom.patch_global {
  ui = 'ff',
  sources = { { name = 'file_rec', params = {} } },
  sourceParams = {
    file_rec = {
      ignoredDirectories = { '.git', 'target', 'node_modules' },
    },
  },
  uiParams = {
    ff = {
      split = 'floating',
      floatingBorder = 'rounded',
      startFilter = true,
      filterFloatingPosition = 'top',
      previewFloating = true,
      previewSplit = 'vertical',
      previewFloatingBorder = 'rounded',
      prompt = ' ',
    },
  },
  filterParams = {
    matcher_fzf = {
      highlightMatched = 'Search',
    },
  },
  sourceOptions = {
    _ = {
      ignoreCase = true,
      matchers = { 'matcher_fzf' },
      sorters = { 'sorter_fzf' },
    },
  },
  kindOptions = {
    file = {
      defaultAction = 'open',
    },
  },
}

local function m(...)
  local args = { ... }
  table.insert(args, { buffer = true })
  vim.keymap.set(unpack(args))
end

au('FileType', {
  pattern = 'ddu-ff',
  callback = function()
    vim.api.nvim_input '<Esc>'
    vim.opt_local.cursorline = true
    m('n', '<CR>', ddu.ui.ff.do_action._fn 'itemAction')
    m('n', 'i', ddu.ui.ff.do_action._fn 'openFilterWindow')
    m('n', 'q', ddu.ui.ff.do_action._fn 'quit')
  end,
})

au('FileType', {
  pattern = 'ddu-ff-filter',
  callback = function()
    m({ 'n', 'i' }, '<CR>', ddu.ui.ff.do_action._fn 'itemAction')
    m('i', '<C-k>', ddu.ui.do_action._fn 'cursorPrevious')
    m('i', '<C-j>', ddu.ui.do_action._fn 'cursorNext')
    m('i', '<C-c>', ddu.ui.do_action._fn 'quit')
  end,
})
