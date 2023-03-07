vim.g.neo_tree_remove_legacy_commands = 1

local neotree = require 'neo-tree'

neotree.setup {
  close_if_last_window = true,
  popup_border_style = 'rounded',
  source_selector = {
    statusline = false,
    content_layout = 'center',
  },
  default_component_configs = {
    indent = {
      indent_marker = ' ',
      last_indent_marker = ' ',
    },
    icon = {
      folder_closed = '󰉋',
      folder_open = '󰝰',
      folder_empty = '󰷏',
      default = '',
    },
    modified = {
      symbol = '',
    },
    git_status = {
      symbols = {
        added = '',
        modified = '',
        deleted = '',
        renamed = '',

        untracked = '',
        ignored = '',
        unstaged = '',
        staged = '',
        conflict = '',
      },
      align = 'right',
    },
  },
  window = {
    width = 36,
  },
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_hidden = false,
    },
    follow_current_file = true,
  },
  buffers = {
    follow_current_file = true,
  },
}