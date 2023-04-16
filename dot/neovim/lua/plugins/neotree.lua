vim.g.neo_tree_remove_legacy_commands = 1

local hl = vim.api.nvim_set_hl
local ui = require 'core.ui'
local neotree = require 'neo-tree'

neotree.setup {
  close_if_last_window = true,
  popup_border_style = 'rounded',
  source_selector = {
    statusline = false,
    content_layout = 'center',
  },
  enable_diagnostics = true,
  default_component_configs = {
    diagnostics = {
      symbols = {
        hint = ui.bug,
        info = ui.bug,
        warn = ui.bug,
        error = ui.bug,
      },
    },
    indent = {
      indent_marker = ' ',
      last_indent_marker = ' ',
      with_expanders = true,
      expander_collapsed = ui.chevron.right,
      expander_expanded = ui.chevron.down,
      expander_highlight = 'NeoTreeExpander',
    },
    icon = {
      folder_closed = '󰉋',
      folder_open = '󰝰',
      folder_empty = '󰷏',
      default = '',
    },
    modified = {
      symbol = '',
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

hl(0, 'NeoTreeGitIgnored', { link = 'CursorLineNr' })
hl(0, 'NeoTreeModified', { link = '@variable.builtin' })
hl(0, 'NeoTreeDirectoryName', { link = 'NeoTreeFileName' })
