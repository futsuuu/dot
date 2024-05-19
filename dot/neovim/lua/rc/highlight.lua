local api = vim.api

local M = {}

---@param name string
---@param val vim.api.keyset.highlight
local function set(name, val)
  local function fn()
    api.nvim_set_hl(0, name, val)
  end
  fn()
  api.nvim_create_autocmd('ColorScheme', { callback = fn })
end

---@param highlights { [string]: string | vim.api.keyset.highlight }
function M.set(highlights)
  for name, val in pairs(highlights) do
    if type(val) == 'string' then
      set(name, { link = val })
    else
      set(name, val)
    end
  end
end

---@class rc.Highlight
---@field info? vim.api.keyset.hl_info
---@field name string
local Highlight = {}
Highlight.__index = Highlight

---@param hl_name string
---@return rc.Highlight
function M.get(hl_name)
  local self = setmetatable({}, Highlight)

  self.name = hl_name
  local info = api.nvim_get_hl(0, { name = hl_name, link = false })
  if not vim.tbl_isempty(info) then
    self.info = info
  end

  return self
end

---@param hl_name string
---@param hl fun(): rc.Highlight
---@return rc.Highlight
function M.ensure(hl_name, hl)
  local self = M.get(hl_name)
  if not self.info then
    self.info = hl().info
    self:set()
  end
  return self
end

---@param other rc.Highlight | string
---@return self
function Highlight:extend(other)
  if type(other) == 'string' then
    other = M.get(other)
  end
  self.info = vim.tbl_extend('keep', self.info or {}, other.info or {})
  return self
end

---@param new_hl_name string?
---@return self
function Highlight:set(new_hl_name)
  self.name = new_hl_name or self.name
  api.nvim_set_hl(0, self.name, self.info --[[@as table]] or {})
  return self
end

return M
