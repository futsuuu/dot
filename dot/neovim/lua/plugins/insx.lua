local insx = require 'insx'

local function recipe(name)
  return require('insx.recipe.' .. name)
end

local delete_pair = recipe 'delete_pair'
local jump_next = recipe 'jump_next'
local pair_spacing = recipe 'pair_spacing'
local fast_break = recipe 'fast_break'
local fast_wrap = recipe 'fast_wrap'

local auto_pair_ext = recipe 'auto_pair_ext'

local with, add, esc = insx.with, insx.add, insx.helper.regex.esc

require('insx.preset.standard').setup_cmdline_mode {
  cmdline = {
    enabled = true,
  },
}

for _, quote in ipairs { '"', "'", '`' } do
  -- jump_out
  add(
    quote,
    jump_next {
      jump_pat = {
        [[\\\@<!\%#]] .. esc(quote) .. [[\zs]],
      },
    }
  )

  -- auto_pair
  local re = [[\%([^]] .. quote .. [[]\|^\)]] .. quote:rep(2) .. [[\%#]]
  local pair_with = {
    with.nomatch(re),
  }
  -- lifetime in Rust
  if quote == "'" then
    vim.list_extend(pair_with, {
      with.nomatch [[&\%#]],
      with.nomatch [[\h\w*<.*\%#]],
    })
  end
  add(
    quote,
    with(
      auto_pair_ext.strings {
        open = quote,
        close = quote,
      },
      pair_with
    )
  )
  add(
    quote,
    with(
      auto_pair_ext.strings {
        open = quote,
        close = quote:rep(3),
      },
      {
        with.match(re),
      }
    )
  )

  -- delete_pair
  add(
    '<BS>',
    delete_pair.strings {
      open_pat = esc(quote),
      close_pat = esc(quote),
    }
  )
end

-- pairs
for open, close in pairs {
  ['('] = ')',
  ['['] = ']',
  ['{'] = '}',
} do
  -- jump_out
  add(
    close,
    jump_next {
      jump_pat = {
        [[\%#]] .. esc(close) .. [[\zs]],
      },
    }
  )

  -- auto_pair
  local pair = auto_pair_ext {
    open = open,
    close = close,
  }
  if open == '[' then
    add(
      '[',
      with(pair, {
        with.nomatch [[\033\%#]],
        with.nomatch [[\x1b\%#]],
      })
    )
  else
    add(open, pair)
  end

  -- delete_pair
  add(
    '<BS>',
    delete_pair {
      open_pat = esc(open),
      close_pat = esc(close),
    }
  )

  -- spacing
  add(
    '<Space>',
    pair_spacing.increase {
      open_pat = esc(open),
      close_pat = esc(close),
    }
  )
  add(
    '<BS>',
    pair_spacing.decrease {
      open_pat = esc(open),
      close_pat = esc(close),
    }
  )

  -- fast_break
  add(
    '<CR>',
    fast_break {
      open_pat = esc(open),
      close_pat = esc(close),
      split = nil,
      html_attrs = true,
      arguments = true,
    }
  )

  -- fast_wrap
  add(
    '<C-]>',
    fast_wrap {
      close = close,
    }
  )
end

-- tags
add(
  '<CR>',
  fast_break {
    open_pat = insx.helper.search.Tag.Open,
    close_pat = insx.helper.search.Tag.Close,
  }
)

add('>', jump_next { jump_pat = [[\%#>\zs]] })
add('<BS>', delete_pair { open_pat = '<', close_pat = '>' })

local tag_ft = with.filetype { 'html', 'typescriptreact', 'javascriptreact', 'markdown' }
add(
  '/',
  with(auto_pair_ext { open = ' />', close = '' }, {
    tag_ft,
    with.match [[<.*[^>]\%#]],
  })
)
