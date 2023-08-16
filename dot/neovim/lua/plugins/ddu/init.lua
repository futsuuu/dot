local ui = require 'core.ui'
local ddu = require('utils').call 'ddu'
local custom = ddu.custom
local patch, patchl = custom.patch_global, custom.patch_local

local layouts = require 'plugins.ddu.layouts'
require 'plugins.ddu.keymaps'

---@param override? table
local function preview_win_opts(override)
  override = override or {}
  local opts = vim.tbl_extend('keep', override, {
    signcolumn = 'no',
    statuscolumn = ' ',
    modifiable = 0,
    foldcolumn = 0,
    foldenable = 0,
    number = 0,
    wrap = 0,
  })
  local r = {}
  for key, value in pairs(opts) do
    table.insert(r, { '&' .. key, value })
  end
  return r
end

patch {
  sources = {
    { name = 'file_rec' },
  },
  sourceOptions = {
    _ = {
      matchers = { 'matcher_fzf' },
      sorters = { 'sorter_fzf' },
      converters = { 'converter_devicon' },
      ignoreCase = true,
    },
    ghq = { defaultAction = 'cd' },
    lsp_documentSymbol = { converters = { 'converter_lsp_symbol' } },
    lsp_workspaceSymbol = { converters = { 'converter_lsp_symbol' } },
  },
  sourceParams = {
    file_rec = {
      ignoredDirectories = {
        '.git',
        'target',
        'node_modules',
        'dist',
        '__pycache__',
        '.venv',
      },
    },
    mr = { kind = 'mrw' },
    ghq = {
      display = 'relative',
      rootPath = vim.fn.expand '~/dev',
    },
    rg = {
      args = { '--column', '--no-heading', '--color', 'never' },
    },
    lsp = {
      includeDeclaration = false,
    },
  },
  columnParams = {
    icon_filename = {
      padding = 2,
    },
    lsp_symbols = {
      collapsedIcon = ui.chevron.right,
      expandedIcon = ui.chevron.down,
      iconWidth = 4,
      kindLabels = ui.kind,
    },
  },
  filterParams = {
    matcher_fzf = {
      highlightMatched = 'Search',
    },
    converter_devicon = {
      padding = 1,
    },
    converter_lsp_symbol = {
      iconMap = ui.kind
    }
  },
  uiParams = {
    ff = {
      startFilter = true,
      startAutoAction = true,
      autoAction = { name = 'preview' },
      previewSplit = 'vertical',
      previewFloating = true,
      previewWindowOptions = preview_win_opts(),
      split = 'floating',
      floatingBorder = 'rounded',
      highlights = {
        floatingCursorLine = 'Visual',
      },
    },
    filer = {
      split = 'vertical',
      winWidth = 40,
      splitDirection = 'topleft',
      sort = 'filename',
      sortTreesFirst = true,
      displayRoot = false,
    },
  },
  kindOptions = {
    file = { defaultAction = 'open' },
    colorscheme = { defaultAction = 'set' },
    lsp = { defaultAction = 'open' },
    lsp_codeAction = { defaultAction = 'apply' },
    ui_select = { defaultAction = 'select' },
    ['nvim-notify'] = { defaultAction = 'open' },
  },
}

patch(layouts.ff(90, 80, true))

patchl('ghq', {
  sources = { { name = 'ghq' } },
  uiParams = {
    ff = {
      startAutoAction = false,
    },
  },
})

patchl('ghq', layouts.ff(50, 50, false))

patchl('code-action', {
  sources = { { name = 'lsp_codeAction' } },
  uiParams = {
    ff = {
      startFilter = false,
    },
  },
})

patchl('definition', {
  sources = { { name = 'lsp_definition' } },
  uiParams = {
    ff = {
      startFilter = false,
      previewWindowOptions = preview_win_opts {
        statuscolumn = '%= %l ',
        number = 1,
      },
    },
  },
})

patchl('references', {
  sources = { { name = 'lsp_references' } },
  uiParams = {
    ff = {
      startFilter = false,
      previewWindowOptions = preview_win_opts {
        statuscolumn = '%= %l ',
        number = 1,
      },
    },
  },
})

patchl('rg-live', {
  sources = {
    {
      name = 'rg',
      options = {
        matchers = {},
        volatile = true,
      },
    },
  },
})

patchl('notify', {
  sources = { { name = 'nvim-notify' } },
  uiParams = {
    ff = {
      startFilter = false,
    },
  },
})

patchl('filer', {
  ui = 'filer',
  sources = {
    { name = 'file' },
  },
  actionOptions = {
    narrow = { quit = false },
    cd = { quit = false },
  },
  sourceOptions = {
    _ = {
      columns = { 'icon_filename' },
      converters = {},
    },
  },
})
