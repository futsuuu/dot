local telescope = require 'telescope'

telescope.setup {
  defaults = {
    sorting_strategy = 'ascending',
    layout_config = {
      horizontal = {
        prompt_position = 'top',
        width = 0.89,
        preview_width = 0.5,
      },
    },
    file_ignore_patterns = { '^%.git' },
  },
  pickers = {},
  extensions = {},
}

telescope.load_extension 'mr'
if vim.uv.fs_stat(require('zf').get_path()) then
  telescope.load_extension 'zf-native'
end
