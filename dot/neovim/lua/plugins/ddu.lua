local au = vim.api.nvim_create_autocmd
local optl = vim.opt_local

local ddu = require('utils').call 'ddu'
local ui = ddu.ui

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
      startFilter = true,
      autoAction = {
        name = 'preview',
      },
      floatingBorder = 'rounded',
      previewFloatingBorder = { '─', '─', '╮', '│', '╯', '─', '─', '▕' },
      previewSplit = 'vertical',
      previewFloating = true,
      previewWindowOptions = {
        { '&signcolumn', 'no' },
        { '&statuscolumn', ' ' },
        { '&foldcolumn', 0 },
        { '&foldenable', 0 },
        { '&number', 0 },
        { '&wrap', 0 },
        { '&scrolloff', 0 },
      },
      prompt = '',
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

local floor = math.floor

local function set_size()
  local editor_height = vim.o.lines
  local editor_width = vim.o.columns
  local filter_height = 3

  local win_height = floor(editor_height * 0.8) - filter_height
  local win_row = floor((editor_height - win_height) / 2)
  local win_width = floor(editor_width * 0.85)
  local win_col = floor((editor_width - win_width) / 2) - 1
  local preview_width = floor(win_width * 0.5)
  local preview_col = win_col - preview_width - 10

  ddu.custom.patch_global {
    uiParams = {
      ff = {
        filterFloatingPosition = 'top',
        winRow = win_row,
        winCol = win_col,
        winWidth = win_width,
        winHeight = win_height,
        previewCol = preview_col,
        previewWidth = preview_width,
      },
    },
  }
end

set_size()

local function m(...)
  local args = { ... }
  table.insert(args, { buffer = true })
  vim.keymap.set(unpack(args))
end

au('FileType', {
  pattern = 'ddu-ff',
  callback = function()
    optl.cursorline = true
    optl.statuscolumn = ' '
    m('n', '<CR>', ui.ff.do_action._fn 'itemAction')
    m('n', 'i', ui.ff.do_action._fn 'openFilterWindow')
    m('n', 'q', ui.ff.do_action._fn 'quit')
  end,
})

au('FileType', {
  pattern = 'ddu-ff-filter',
  callback = function()
    optl.statuscolumn = ' %#Function#%*  '
    optl.cursorline = false
    vim.defer_fn(function()
      optl.cursorline = false
    end, 200)
    m({ 'n', 'i' }, '<CR>', ui.ff.do_action._fn 'itemAction')
    m({ 'n', 'i' }, '<C-c>', ui.do_action._fn 'quit')
    m('i', '<C-k>', ui.do_action._fn 'cursorPrevious')
    m('i', '<C-j>', ui.do_action._fn 'cursorNext')
    m('n', 'k', ui.do_action._fn 'cursorPrevious')
    m('n', 'j', ui.do_action._fn 'cursorNext')
  end,
})
