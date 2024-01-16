require 'gui.options'

local options = {
  hide_mouse_when_typing = true,
  cursor_vfx_mode = 'railgun',
  floating_shadow = false,
}

for k, v in pairs(options) do
  vim.g['neovide_' .. k] = v
end
