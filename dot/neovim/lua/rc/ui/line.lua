local M = {}

---@param str string
---@param hl_group string
---@return string
function M.with_hl(str, hl_group)
  return '%#' .. hl_group .. '#' .. str .. '%*'
end

M._funcs = {}

---@param func fun(): string
---@param args? string
---@return string
function M.as_opt(func, args)
  local idx
  if M._funcs[func] then
    idx = M._funcs[func]
  else
    idx = #M._funcs + 1
    M._funcs['n' .. idx] = func
    M._funcs[func] = idx
  end
  args = args or ''
  return "%!v:lua.require'rc.ui.line'._funcs.n" .. idx .. '(' .. args .. ')'
end

return M
