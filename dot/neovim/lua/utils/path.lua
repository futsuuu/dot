---@class Utils.Path
---@field table string[]
---@field private return_copy boolean
local Path = {}

Path.sep = package.config:sub(1, 1)

---Create new Utils.Path instance
---@param path string?
---@return Utils.Path
function Path.new(path)
  path = path or '~'
  local self = setmetatable({}, {
    __index = Path,
    __div = Path.join,
    __tostring = Path.str,
  })

  path = vim.fn.expand(path)

  self.table = path:split '/\\'
  self.return_copy = true
  return self
end

function Path:str()
  return (self.sep == '/' and '/' or '') .. self.sep:join(self.table)
end

---@param str string
function Path:join(str)
  self = self:copy()
  for _, v in ipairs(str:split '/\\') do
    table.insert(self.table, v)
  end
  return self
end

function Path:parent()
  self = self:copy()
  table.remove(self.table)
  return self
end

function Path:name()
  return self.table[#self.table]
end

function Path:len()
  return #self.table
end

function Path:copy()
  return Path.new(self:str())
end

return Path
