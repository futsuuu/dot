local insx = require('insx')

local function recipe(name)
  return require('insx.recipe.' .. name)
end

local delete_pair = recipe('delete_pair')
local jump_next = recipe('jump_next')
local pair_spacing = recipe('pair_spacing')
local fast_break = recipe('fast_break')
local fast_wrap = recipe('fast_wrap')

local auto_pair_ext = recipe('auto_pair_ext')

local helper = insx.helper
local regex = helper.regex
local with, add, esc, Tag = insx.with, insx.add, regex.esc, helper.search.Tag

do
  local standard = require('insx.preset.standard')
  standard.config = {
    cmdline = {
      enabled = true,
    },
  }
  standard.setup_cmdline_mode()
end

for _, quote in ipairs({ '"', "'", '`' }) do
  -- jump_out
  add(
    quote,
    jump_next({
      jump_pat = {
        [[\\\@<!\%#]] .. esc(quote) .. [[\zs]],
      },
    })
  )

  -- auto_pair
  local re = [[\%([^]] .. quote .. [[]\|^\)]] .. quote:rep(2) .. [[\%#]]
  local pair_with = {
    with.nomatch(re),
  }
  -- lifetime in Rust
  if quote == "'" then
    vim.list_extend(pair_with, {
      with.nomatch([[&\%#]]),
      with.nomatch([[\h\w*<.*\%#]]),
    })
  end
  -- "| ==> "|"
  add(
    quote,
    with(
      auto_pair_ext.strings({
        open = quote,
        close = quote,
      }),
      pair_with
    )
  )
  -- ""| ==> """|"""
  add(
    quote,
    with(
      auto_pair_ext.strings({
        open = quote,
        close = quote:rep(3),
      }),
      {
        with.match(re),
      }
    )
  )

  -- ```|```    ```
  --         => |
  --            ```
  add(
    '<CR>',
    with({
      action = function(ctx)
        local row, col = ctx.row(), ctx.col()
        ctx.send('<CR><CR>')
        ctx.move(row + 1, col)
      end,
    }, { with.match(quote:rep(3) .. [[.*\%#]] .. quote:rep(3)) })
  )

  -- delete_pair
  add(
    '<BS>',
    delete_pair.strings({
      open_pat = esc(quote),
      close_pat = esc(quote),
    })
  )
end

-- pairs
for open, close in pairs({
  ['('] = ')',
  ['['] = ']',
  ['{'] = '}',
}) do
  -- jump_out
  add(
    close,
    jump_next({
      jump_pat = {
        [[\%#]] .. esc(close) .. [[\zs]],
      },
    })
  )

  -- auto_pair
  local pair = auto_pair_ext({
    open = open,
    close = close,
  })
  if open == '[' then
    add(
      '[',
      with(pair, {
        with.nomatch([[\033\%#]]),
        with.nomatch([[\027\%#]]),
        with.nomatch([[\x1b\%#]]),
      })
    )
  else
    add(open, pair)
  end

  -- delete_pair
  add(
    '<BS>',
    delete_pair({
      open_pat = esc(open),
      close_pat = esc(close),
    })
  )

  -- spacing
  add(
    '<Space>',
    pair_spacing.increase({
      open_pat = esc(open),
      close_pat = esc(close),
    })
  )
  add(
    '<BS>',
    pair_spacing.decrease({
      open_pat = esc(open),
      close_pat = esc(close),
    })
  )

  -- fast_break
  add(
    '<CR>',
    fast_break({
      open_pat = esc(open),
      close_pat = esc(close),
      split = nil,
      html_attrs = true,
      arguments = true,
    })
  )

  -- fast_wrap
  add(
    '<C-]>',
    fast_wrap({
      close = close,
    })
  )
end

-- tags
add(
  '<CR>',
  fast_break({
    open_pat = Tag.Open,
    close_pat = Tag.Close,
  })
)

add('<BS>', delete_pair({ open_pat = '<', close_pat = '>' }))

local tag_ft = with.filetype({
  'astro',
  'html',
  'xml',
  'typescriptreact',
  'javascriptreact',
  'markdown',
})

local arrowfunc_ft = with.filetype({
  'astro',
  'typescript',
  'javascript',
  'typescriptreact',
  'javascriptreact',
})

-- <foo| ==> <foo>|</foo>
add(
  '>',
  with({
    action = function(ctx)
      local before = vim.split(ctx.before())
      local name = before[#before]:match('%a[%w%.]*')
      local row, col = ctx.row(), ctx.col()
      ctx.send(('></' .. (name or '') .. '>'))
      ctx.move(row, col + 1)
    end,
    enabled = function(ctx)
      return regex.match(ctx.before(), Tag.Open:gsub('>$', '')) ~= nil
        and regex.match(ctx.after(), Tag.Close) == nil
        and ctx.before():match('function') == nil
        and ctx.before():match('|') == nil
        and ctx.after():match('^[%(%)]') == nil
    end,
  }, { tag_ft })
)

-- (hello|) ==> (hello) => {|}
add(
  '>',
  with({
    action = function(ctx)
      ctx.send('<Del>) => {}<Left>')
    end,
    enabled = function(ctx)
      return ctx.before():match('%([%w, ]*') and ctx.after():match('^%)')
    end,
  }, { arrowfunc_ft })
)

-- <foo| ==> <foo />
add(
  '/',
  with({
    action = function(ctx)
      local row, col = ctx.row(), ctx.col()
      if ctx.before():match('%s+$') then
        ctx.send('/>')
        ctx.move(row, col + 2)
      else
        ctx.send(' />')
        ctx.move(row, col + 3)
      end
    end,
    enabled = function(ctx)
      return regex.match(ctx.before(), Tag.Open:gsub('>$', '')) ~= nil and regex.match(ctx.after(), [[\s*/>]]) == nil
    end,
  }, { tag_ft })
)

-- <foo>|</foo> ==> <foo|
add(
  '<BS>',
  with({
    action = function(ctx)
      local close_tag_len = ctx.after():match('^</[^>]*>'):len()
      ctx.send('<BS>' .. ('<Del>'):rep(close_tag_len))
    end,
    enabled = function(ctx)
      return regex.match(ctx.before(), Tag.Open .. [[\%$]]) ~= nil
        and regex.match(ctx.after(), [[\%^]] .. Tag.Close) ~= nil
    end,
  }, { tag_ft })
)

-- <foo />| ==> <foo|
add(
  '<BS>',
  with({
    action = function(ctx)
      local space_len = ctx.before():match('(%s*)/>$'):len()
      ctx.send(('<BS>'):rep(space_len + 2))
    end,
    enabled = function(ctx)
      return regex.match(ctx.before(), Tag.Open:gsub('>$', '/>') .. [[\%$]]) ~= nil
    end,
  }, { tag_ft })
)
