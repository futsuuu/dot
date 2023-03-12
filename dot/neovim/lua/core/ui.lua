local M = {}

---@param percentage integer
function M.progressbar(percentage)
  if not percentage then
    return ''
  end
  local max_length = 25
  local length = math.floor(percentage / 4)
  return string.format(
    ' %s%% ▓%s▓%s',
    percentage,
    string.rep('█', length),
    string.rep('▒', max_length - length)
  )
end

M.status = {
  check = '',
  dots = '',
  close = '',
}

M.kind = {
  Text = '',
  String = '',
  Number = '󰎠',
  Boolean = '',
  Null = 'ﳠ',
  File = '',
  Folder = '',
  Method = '',
  Function = '',
  Constructor = '',
  Field = '',
  Variable = '',
  Constant = '',
  Class = '',
  Interface = '',
  Package = '',
  Module = '',
  Namespace = '',
  Object = '',
  Array = '',
  Property = '',
  Unit = '',
  Keyword = '',
  Snippet = '',
  Color = '',
  Reference = '',
  Enum = '',
  EnumMember = '',
  Value = '',
  Struct = '',
  Event = '',
  Operator = '',
  TypeParameter = '',
}

return M
