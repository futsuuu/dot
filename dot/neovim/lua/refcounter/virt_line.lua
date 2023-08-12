local api = vim.api

local config = require 'refcounter.config'

---@class refcounter.VirtLine
---@field ns integer
---@field buf buffer
local M = {}

---@param ns integer
---@param buf buffer
---@return refcounter.VirtLine
function M.new(ns, buf)
  return setmetatable({
    ns = ns,
    buf = buf,
  }, {
    __index = M,
  })
end

---@param line integer
---@param text string
function M:set(line, text)
  if line > api.nvim_buf_line_count(self.buf) then
    return
  end
  ---@type string
  local indent = api.nvim_buf_get_lines(self.buf, line, line + 1, false)[1]:match '^(%s*)'
  api.nvim_buf_set_extmark(self.buf, self.ns, line, 0, {
    virt_lines_above = true,
    virt_lines = {
      { { indent }, { text, config.highlight } },
    },
  })
end

function M:del()
  local extmarks = api.nvim_buf_get_extmarks(self.buf, self.ns, 0, -1, {})
  for _, extmark in ipairs(extmarks) do
    api.nvim_buf_del_extmark(self.buf, self.ns, extmark[1])
  end
end

return M
