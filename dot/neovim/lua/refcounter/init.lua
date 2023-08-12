local api = vim.api

local Main = require 'refcounter.main'

local M = {}

---@type table<buffer, refcounter.Main>
M.counters = {}

---@param buf? buffer
function M.main(buf)
  buf = buf or api.nvim_get_current_buf()

  if not api.nvim_buf_is_valid(buf) or buf ~= api.nvim_get_current_buf() then
    return
  end

  if M.counters[buf] then
    M.counters[buf]:stop()
  else
    local main = Main.new(buf)
    if not main then
      return
    end
    M.counters[buf] = main
  end

  M.counters[buf]:start()
end

function M.cleanup()
  for buf, _ in pairs(M.counters) do
    if not api.nvim_buf_is_valid(buf) then
      M.counters[buf]:stop()
      M.counters[buf] = nil
    end
  end
end

function M.setup()
  local augroup = api.nvim_create_augroup('refcounter', { clear = true })

  api.nvim_create_autocmd({ 'LspAttach', 'TextChanged', 'BufEnter', 'CursorHold' }, {
    callback = function(args)
      M.main(args.buf)
    end,
    group = augroup,
  })

  api.nvim_create_autocmd('BufLeave', {
    callback = M.cleanup,
    group = augroup,
  })
end

return M
