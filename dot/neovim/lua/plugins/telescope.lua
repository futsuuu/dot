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
  extensions = {
    file_browser = {
      theme = 'ivy',
      layout_config = {
        height = math.huge,
        preview_width = 0.6,
      },
      borderchars = {
        prompt = { '─', '│', ' ', '│', '╭', '╮', '│', '│' },
        results = { ' ', ' ', '─', '│', ' ', ' ', '─', '╰' },
        preview = { '─', '│', '─', '│', '╭', '┤', '╯', '┴' },
      },
      display_stat = { size = true },
      hidden = true,
      mappings = {
        i = {
          ['<bs>'] = false,
        },
      },
    },
  },
}

telescope.load_extension 'mr'
telescope.load_extension 'file_browser'
if vim.uv.fs_stat(require('zf').get_path()) then
  telescope.load_extension 'zf-native'
end
