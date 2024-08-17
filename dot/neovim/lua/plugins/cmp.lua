local cmp = require 'cmp'

local hl = require 'rc.highlight'
local ui = require 'rc.ui'

local opts = {}

opts.sources = {
  { name = 'nvim_lsp' },
  { name = 'nvim_lsp_signature_help' },
  { name = 'snippy' },
  { name = 'path' },
  { name = 'buffer' },
  { name = 'crates' },
}

opts.completion = {
  completeopt = vim.o.completeopt,
}

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
end

local function feedkey(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local snippy = require 'snippy'
local mapping = cmp.mapping

opts.mapping = mapping.preset.insert {
  ['<Tab>'] = mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif snippy.can_jump(1) then
      feedkey('<Plug>(snippy-expand-or-advance)', '')
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end, { 'i', 'c', 's' }),
  ['<S-Tab>'] = mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif snippy.can_jump(-1) then
      feedkey('<Plug>(snippy-previous)', '')
    else
      fallback()
    end
  end, { 'i', 'c', 's' }),
  ['<CR>'] = mapping.confirm {
    select = true,
  },
  ['<C-e>'] = mapping.abort(),
  ['<C-d>'] = mapping.scroll_docs(-4),
  ['<C-f>'] = mapping.scroll_docs(4),
}

opts.snippet = {
  expand = function(args)
    snippy.expand_snippet(args.body)
  end,
}

hl.set {
  PmenuThumb = 'Normal',
}
local border = 'rounded'

opts.window = {
  completion = {
    border = border,
    winhighlight = 'Normal:Pmenu,CursorLine:PmenuSel,FloatBorder:FloatBorder,Search:None',
    col_offset = -4,
    side_padding = 0,
    scrollbar = true,
    scrolloff = 8,
    winblend = 11,
  },
  documentation = {
    border = border,
    winhighlight = 'Normal:Pmenu,FloatBorder:FloatBorder,Search:None',
    winblend = 11,
  },
}

opts.formatting = {
  fields = { 'kind', 'abbr', 'menu' },
  ---@type fun(entry, vim_item): any
  format = function(_, vim_item)
    do
      local kind
      if vim_item.kind == 'File' then
        local icon = require('clico').get { path = vim_item.abbr }
        kind = icon.icon
        vim_item.kind_hl_group = icon.hl
      else
        kind = ui.kind[vim_item.kind]
      end
      vim_item.kind = ' ' .. kind .. '⠀'
    end
    vim_item.abbr = ui.truncate(vim_item.abbr:gsub(vim.pesc '...', ui.ellipsis), 50)
    do
      local menu = vim_item.menu or ''
      if vim.bo.filetype == 'rust' then
        menu = menu
          :gsub('%(use ([^%)]+)%)%s*(.*)', '%2 (%1)')
          :gsub('%(alias ([^%)]+)%)%s*(.*)', '%2 (alias %1)')
          :gsub('%(as [^%)]+%)', '')
          :gsub('unsafe ', '')
          :gsub('const ', '')
      end
      vim_item.menu = ui.truncate(vim.fn.trim(menu), 70)
    end
    return vim_item
  end,
}

cmp.setup(opts)

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  },
})

if border ~= 'none' then
  local thumb = {}
  for _ = 1, vim.o.lines do
    table.insert(thumb, '┃')
  end
  require('cmp.utils.buffer').cache = setmetatable({}, {
    ---@param name string|integer
    ---@param buf buffer
    __newindex = function(t, name, buf)
      if type(name) == 'string' and name:find 'thumb_buf' then
        vim.api.nvim_buf_set_lines(buf, 0, 1, false, thumb)
      end
      rawset(t, name, buf)
    end,
  })
end
