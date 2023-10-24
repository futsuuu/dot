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

for _, e in ipairs {
  'mr',
  'file_browser',
  'zf-native',
} do
  telescope.load_extension(e)
end
