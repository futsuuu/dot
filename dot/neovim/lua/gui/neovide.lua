require 'gui.options'

local options = {
  hide_mouse_when_typing = true,
  cursor_vfx_mode = 'railgun',
}

for k, v in pairs(options) do
  vim.g['neovide_' .. k] = v
end
