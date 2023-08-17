local api = vim.api

local Main = require 'refcounter.main'

local M = {}

---@type boolean
M.enabled = true
---@type table<buffer, refcounter.Main>
M.counters = {}

---@param buf? buffer
function M.main(buf)
  if not M.enabled then
    return
  end

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

---@param all? boolean
function M.cleanup(all)
  for buf, _ in pairs(M.counters) do
    local is_valid = api.nvim_buf_is_valid(buf)
    if all or not is_valid then
      M.counters[buf]:stop()
      if is_valid then
        M.counters[buf].virt_line:del()
      end
      M.counters[buf] = nil
    end
  end
end

function M.disable()
  M.enabled = false
  M.cleanup(true)
end

function M.enable()
  M.enabled = true
  M.main()
end

function M.toggle()
  (M.enabled and M.disable or M.enable)()
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
    callback = function()
      M.cleanup()
    end,
    group = augroup,
  })

  local cmd = api.nvim_create_user_command

  cmd('RefcounterDisable', M.disable, {})
  cmd('RefcounterEnable', M.enable, {})
  cmd('RefcounterToggle', M.toggle, {})
end

return M
