-- https://github.com/luukvbaal/statuscol.nvim/blob/main/lua/statuscol/builtin.lua
local v = vim.v
local statuscol = require 'statuscol'
local builtin = require 'statuscol.builtin'
local ffi = require 'statuscol.ffidef'
local C = ffi.C

vim.opt.numberwidth = 6

local function foldfunc(args)
  local width = C.compute_foldcolumn(args.wp, 0)
  if width ~= 1 then
    return builtin.foldfunc(args)
  end

  local foldinfo = C.fold_info(args.wp, v.lnum)
  local level = foldinfo.level

  if level == 0 then
    return ' %*'
  end

  local closed = foldinfo.lines > 0
  local first_level = level - (closed and 1 or 0)
  if first_level < 1 then
    first_level = 1
  end

  local str = '%#FoldLevel' .. tostring(level) .. '#'

  if closed then
    str = str .. vim.opt.fillchars:get().foldclose
  elseif foldinfo.start == v.lnum and first_level + 1 > foldinfo.llevel then
    str = str .. ' '
  else
    local status, next_foldinfo = pcall(C.fold_info, args.wp, v.lnum + 1)
    if not status then
      str = str .. ' '
    else
      local next_level = next_foldinfo.level
      if level > next_level then
        str = str .. ' '
      elseif level == next_level then
        if next_foldinfo.start == v.lnum + 1 then
          str = str .. ' '
        else
          str = str .. ' '
        end
      else
        str = str .. ' '
      end
    end
  end

  return str .. '%*'
end

statuscol.setup {
  relculright = true,
  bt_ignore = { 'terminal' },
  segments = {
    { text = { ' ', builtin.lnumfunc }, click = 'v:lua.ScLa' },
    { text = { '%s' }, click = 'v:lua.ScSa' },
    {
      text = { '', foldfunc, '' },
      click = 'v:lua.ScFa',
    },
    { text = { '%#IndentBlanklineChar#▕%*' } },
  },
}

vim.api.nvim_create_autocmd({ 'FileType', 'BufWinEnter' }, {
  callback = function(ev)
    ---@type string
    local ft = vim.api.nvim_get_option_value('filetype', { buf = ev.buf })
    for _, ft_ignore in ipairs { 'neo-tree', 'Neogit', 'Overseer' } do
      if ft:find(ft_ignore, nil, true) then
        vim.api.nvim_set_option_value('statuscolumn', '', { buf = ev.buf })
      end
    end
  end,
})
