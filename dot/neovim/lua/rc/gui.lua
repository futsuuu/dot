if not vim.fn.has('gui_running') == 1 then
  return
end

local o = vim.o

o.guifont = 'IosevkaCustom Nerd Font:h11'

if vim.g.neovide then
  local options = {
    hide_mouse_when_typing = true,
    cursor_vfx_mode = '',
    floating_shadow = false,
  }

  for k, v in pairs(options) do
    vim.g['neovide_' .. k] = v
  end
end
