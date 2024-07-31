local api = vim.api

local M = {}

---@class rc.HighlightOperation
---@field reverse? true
---@field extend? string | rc.Highlight
---@field mix? { hl: string | rc.Highlight, ratio: integer }
---@field clear? 'fg' | 'bg' | 'sp'
---@field bold? boolean

---@class rc.Highlight
---@field name string
---@field package operations rc.HighlightOperation[]
local Highlight = {}
---@private
Highlight.__index = Highlight

---@param hl_name string
---@return rc.Highlight
function M.get(hl_name)
  local self = setmetatable({}, Highlight)
  self.name = hl_name
  self.operations = {}
  return self
end

---@param hl_name string
---@param hl fun(): rc.Highlight
---@return rc.Highlight
function M.ensure(hl_name, hl)
  local self = M.get(hl_name)
  if self:exists() then
    return self
  else
    return hl():set(hl_name)
  end
end

---@param new_hl_name string?
---@return self
function Highlight:set(new_hl_name)
  local name = new_hl_name or self.name
  local _self = vim.deepcopy(self)
  local function fn()
    api.nvim_set_hl(0, name, _self:get_hl_info())
  end
  fn()
  vim.api.nvim_create_autocmd('ColorScheme', { callback = fn })
  self.name = name
  return self
end

---@param color string | integer | { r: integer, g: integer, b: integer }
---@return string
local function to_hex(color)
  if type(color) == 'string' then
    return color
  elseif type(color) == 'table' then
    return ('#%02x%02x%02x'):format(color.r, color.g, color.b)
  else
    return ('#%06x'):format(color)
  end
end

---@param color string | integer
---@return { r: integer, g: integer, b: integer }
local function to_rgb(color)
  local r, g, b = to_hex(color):lower():match '^#(%x%x)(%x%x)(%x%x)$'
  return { r = tonumber(r, 16), g = tonumber(g, 16), b = tonumber(b, 16) }
end

---@param base { r: integer, g: integer, b: integer }
---@param other { r: integer, g: integer, b: integer }
---@param ratio number 0.0 ~ 1.0
---@return { r: integer, g: integer, b: integer }
local function mix_colors(base, other, ratio)
  ratio = math.min(math.max(ratio, 0), 1)
  local function clamp(n)
    return math.min(math.max(n, 0), 255)
  end
  return {
    r = clamp(base.r * (1 - ratio) + other.r * ratio),
    g = clamp(base.g * (1 - ratio) + other.g * ratio),
    b = clamp(base.b * (1 - ratio) + other.b * ratio),
  }
end

---@return vim.api.keyset.highlight
function Highlight:get_hl_info()
  local info = api.nvim_get_hl(0, { name = self.name, link = false }) --[[@as table]]
  ---@type vim.api.keyset.highlight
  info = vim.tbl_isempty(info) and {} or info

  for _, op in ipairs(self.operations) do
    local reverse = op.reverse
    if reverse ~= nil then
      info.fg, info.bg = info.bg, info.fg
      info.ctermfg, info.ctermbg = info.ctermbg, info.ctermfg
    end

    local extend = op.extend
    if extend ~= nil then
      if type(extend) == 'string' then
        info = vim.tbl_extend('keep', info, M.get(extend):get_hl_info())
      else
        info = vim.tbl_extend('keep', info, extend:get_hl_info())
      end
    end

    local mix = op.mix
    if mix ~= nil then
      local hl = mix.hl
      if type(hl) == 'string' then
        hl = M.get(hl)
      end
      local other = hl:copy():extend('Normal'):get_hl_info()
      for _, key in ipairs { 'fg', 'bg', 'sp' } do
        if info[key] and other[key] then
          info[key] = to_hex(mix_colors(to_rgb(info[key]), to_rgb(other[key]), mix.ratio / 100))
        end
      end
    end

    local clear = op.clear
    if clear ~= nil then
      info[clear] = nil
    end

    local bold = op.bold
    if bold ~= nil then
      info.bold = bold
    end
  end

  return info
end

---@return rc.Highlight
function Highlight:copy()
  return vim.deepcopy(self)
end

---@return boolean
function Highlight:exists()
  return not vim.tbl_isempty(api.nvim_get_hl(0, { name = self.name }))
end

---@private
---@param op rc.HighlightOperation
function Highlight:push_operation(op)
  table.insert(self.operations, op)
end

---@param other rc.Highlight | string
---@return self
function Highlight:extend(other)
  self:push_operation { extend = other }
  return self
end

---@return self
function Highlight:reverse()
  self:push_operation { reverse = true }
  return self
end

---@return self
function Highlight:clear_fg()
  self:push_operation { clear = 'fg' }
  return self
end

---@return self
function Highlight:clear_bg()
  self:push_operation { clear = 'bg' }
  return self
end

---@param hl string | rc.Highlight
---@param ratio integer 0 ~ 100
---@return self
function Highlight:mix(hl, ratio)
  self:push_operation { mix = { hl = hl, ratio = ratio } }
  return self
end

---@param bold boolean
---@return self
function Highlight:bold(bold)
  self:push_operation { bold = bold }
  return self
end

---@param name string
---@param val vim.api.keyset.highlight | rc.Highlight
local function set(name, val)
  if (getmetatable(val) or {}).__index == Highlight then
    ---@cast val rc.Highlight
    val:set(name)
  else
    ---@cast val vim.api.keyset.highlight
    local function fn()
      api.nvim_set_hl(0, name, val)
    end
    fn()
    api.nvim_create_autocmd('ColorScheme', { callback = fn })
  end
end

---@param highlights { [string]: string | rc.Highlight }
function M.set(highlights)
  for name, val in pairs(highlights) do
    if type(val) == 'string' then
      set(name, { link = val })
    else
      set(name, val)
    end
  end
end

return M
