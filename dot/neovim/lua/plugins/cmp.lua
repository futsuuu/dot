local cmp = require 'cmp'
local vsnip = require('rc.utils').call 'vsnip'

local ui = require 'rc.ui'

local ellipsis_char = ''
local max_label_width = 50
local min_label_width = 30

local opts = {}

opts.sources = {
  { name = 'nvim_lsp' },
  { name = 'nvim_lsp_signature_help' },
  { name = 'vsnip' },
  { name = 'path' },
  { name = 'buffer' },
  { name = 'crates' },
  { name = 'skkeleton' },
}

opts.completion = {
  completeopt = vim.o.completeopt,
}

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local mapping = cmp.mapping

opts.mapping = mapping.preset.insert {
  ['<Tab>'] = mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif vsnip.available(1) == 1 then
      feedkey('<Plug>(vsnip-expand-or-jump)', '')
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end, { 'i', 'c', 's' }),
  ['<S-Tab>'] = mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif vsnip.jumpable(-1) == 1 then
      feedkey('<Plug>(vsnip-jump-prev)', '')
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
    vsnip.anonymous(args.body)
  end,
}

local border = 'none'

opts.window = {
  completion = {
    border = border,
    winhighlight = 'Normal:Pmenu,CursorLine:PmenuSel,FloatBorder:FloatBorder,Search:None',
    col_offset = -2,
    side_padding = 0,
    scrollbar = true,
    scrolloff = 8,
  },
  documentation = {
    border = border,
    winhighlight = 'Normal:Pmenu,FloatBorder:FloatBorder,Search:None',
  },
}

opts.formatting = {
  fields = { 'kind', 'abbr' },
  ---@type fun(entry, vim_item): any
  format = function(_, vim_item)
    local label = vim_item.abbr
    local truncated_label = vim.fn.strcharpart(label, 0, max_label_width)
    if truncated_label ~= label then
      vim_item.abbr = truncated_label .. ellipsis_char
    elseif #label < max_label_width then
      vim_item.abbr = label .. string.rep(' ', min_label_width - #label)
    end
    vim_item.kind = ' ' .. ui.kind[vim_item.kind]
    vim_item.menu = ''
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
