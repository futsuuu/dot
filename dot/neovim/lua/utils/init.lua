local M = setmetatable({
  lsp = nil, ---@module 'utils.lsp'
}, {
  __index = function(t, k)
    t[k] = require('utils.' .. k)
    return t[k]
  end,
})

---@param module_name string
---@return table
function M.call(module_name)
  ---@type metatable
  local metatable = {
    func = module_name,
    children = {},
    value = nil,
  }

  ---@param key string
  function metatable:__index(key)
    local meta = getmetatable(self)
    local child = M.call(meta.func .. '#' .. key)
    meta.children[key] = child
    setmetatable(self, meta)
    return child
  end

  function metatable:__call(...)
    local func_name = getmetatable(self).func ---@type string
    if func_name:match '.+#_fn$' then
      local args = { ... }
      return function()
        return vim.fn[func_name:gsub('#_fn$', '', 1)](unpack(args))
      end
    else
      return vim.fn[func_name](...)
    end
  end

  return setmetatable({}, metatable)
end

function M.lazy_require(modname)
  return setmetatable({}, {
    __index = function(_, k)
      return function()
        return require(modname)[k]()
      end
    end,
  })
end

return M
