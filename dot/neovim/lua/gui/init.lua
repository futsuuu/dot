vim.g.gui_running = vim.fn.has 'gui_running' == 1
if not vim.g.gui_running then
  return
end

if vim.g.neovide then
  require 'gui.neovide'
end
