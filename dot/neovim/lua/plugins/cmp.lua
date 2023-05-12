local cmp = require 'cmp'
local ui = require 'core.ui'
local luasnip = require 'luasnip'

local ellipsis_char = ''
local max_label_width = 50
local min_label_width = 30

local opts = {}

opts.sources = {
  { name = 'nvim_lsp' },
  { name = 'nvim_lsp_signature_help' },
  { name = 'path' },
  { name = 'buffer' },
  { name = 'crates' },
}

opts.completion = {
  completeopt = 'menu,menuone,noinsert',
}

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
end

opts.mapping = cmp.mapping.preset.insert {
  ['<Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end, { 'i', 'c', 's' }),
  ['<S-Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, { 'i', 'c', 's' }),
  ['<CR>'] = cmp.mapping.confirm {
    select = true,
  },
  ['<C-e>'] = cmp.mapping.abort(),
  ['<C-d>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
}

opts.snippet = {
  expand = function(args)
    luasnip.lsp_expand(args.body)
  end,
}

opts.window = {
  completion = {
    border = 'rounded',
    winhighlight = 'Normal:Pmenu,CursorLine:PmenuSel,FloatBorder:FloatBorder,Search:None',
    col_offset = -3,
    side_padding = 0,
    scrollbar = {
      thumb_char = '▐',
      position = 'inside',
    },
    scrolloff = 8,
  },
  documentation = {
    border = 'rounded',
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
