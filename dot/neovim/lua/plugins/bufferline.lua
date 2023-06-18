local map = vim.keymap.set

local bufferline = require 'bufferline'

local ui = require 'core.ui'

bufferline.setup {
  options = {
    custom_areas = {
      right = function()
        local result = {}
        if not package.loaded.overseer then
          return result
        end

        local tasks = require('overseer.task_list').list_tasks { unique = true }
        local tasks_by_status = require('overseer.util').tbl_group_by(tasks, 'status')

        for status, symbol in pairs(ui.status) do
          status = status:upper()
          local task = tasks_by_status[status]
          if task then
            local text = '%#' .. 'Overseer' .. status .. '#' .. symbol .. ' ' .. #task .. ' '
            table.insert(result, { text = text })
          end
        end

        return result
      end,
    },
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
        highlight = 'BufferLineFill',
        separator = false,
      },
      {
        filetype = 'OverseerList',
        text = '',
        highlight = 'WinSeparator',
        separator = true,
      },
    },
  },
}

map('n', '<Space>bh', '<Cmd>BufferLineCyclePrev<CR>')
map('n', '<Space>bl', '<Cmd>BufferLineCycleNext<CR>')
