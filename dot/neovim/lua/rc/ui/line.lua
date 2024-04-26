local M = {}

---@param str string
---@param hl_group string
---@return string
function M.with_hl(str, hl_group)
  return '%#' .. hl_group .. '#' .. str .. '%*'
end

M._funcs = {}
local funcs_count = 0

---@param func fun(): string
---@param args? string
---@return string
function M.as_opt(func, args)
  local idx ---@type string
  if M._funcs[func] then
    idx = M._funcs[func]
  else
    funcs_count = funcs_count + 1
    idx = 'n' .. funcs_count
    M._funcs[idx] = func
    M._funcs[func] = idx
  end
  args = args or ''
  return "%!v:lua.require'rc.ui.line'._funcs." .. idx .. '(' .. args .. ')'
end

return M
