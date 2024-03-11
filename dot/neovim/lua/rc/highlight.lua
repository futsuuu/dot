local api = vim.api

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
return function(highlights)
  for name, val in pairs(highlights) do
    if type(val) == 'string' then
      set(name, { link = val })
    else
      set(name, val)
    end
  end
end
