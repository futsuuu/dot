local M = setmetatable({
  lsp = nil, ---@module 'utils.lsp'
}, {
  __index = function(t, k)
    t[k] = require('rc.utils.' .. k)
    return t[k]
  end,
})

M.fn = setmetatable({}, {
  __index = function(_, key)
    return setmetatable({ key }, {
      __index = function(t, k)
        local r = vim.deepcopy(t)
        table.insert(r, k)
        return r
      end,
      __call = function(t, ...)
        return vim.fn[table.concat(t, '#')](...)
      end,
    })
  end,
})

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
