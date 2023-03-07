require('bufferline').setup {
  options = {
    mode = 'buffers',
    separator_style = 'thick',
    indicator = {},
    show_buffer_close_icons = false,
    always_show_bufferline = true,
    max_name_length = 20,
    tab_size = 22,
    hover = {
      enabled = true,
      delay = 0,
      reveal = { 'close' },
    },
    diagnostics = 'nvim_lsp',
    diagnostics_update_in_insert = true,
    -- count, level, diagnostics_dict, context
    diagnostics_indicator = function(count, _, _, _)
      return ' ' .. count
    end,
    offsets = {
      {
        filetype = 'aerial',
        text = '',
        separator = true,
      },
      {
        filetype = 'neo-tree',
        text = '',
        separator = true,
      },
    },
  },
}
