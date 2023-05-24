local map = vim.keymap.set
local bufferline = require 'bufferline'

bufferline.setup {
  options = {
    mode = 'buffers',
    separator_style = 'slant',
    style_preset = bufferline.style_preset.no_italic,
    themable = true,
    indicator = { style = 'icon', icon = '▎' },
    modified_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    always_show_bufferline = true,
    max_name_length = 20,
    tab_size = 22,
    diagnostics = 'nvim_lsp',
    diagnostics_update_in_insert = true,
    ---@type fun(count: integer, level, diagnostics_dict, context): string
    diagnostics_indicator = function(count, _, _, _)
      return tostring(count)
    end,
    offsets = {
      {
        filetype = 'neo-tree',
        text = 'explorer',
        highlight = 'BufferLineBackGround',
        separator = false,
      },
    },
  },
}

map('n', '<Space>bh', '<Cmd>BufferLineCyclePrev<CR>')
map('n', '<Space>bl', '<Cmd>BufferLineCycleNext<CR>')
