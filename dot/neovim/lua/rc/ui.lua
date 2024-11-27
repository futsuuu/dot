local M = {
  bug = ' ',
  ellipsis = '…',
}

---@param percentage integer?
function M.progressbar(percentage)
  if not percentage then
    return ''
  end
  local max_length = 30
  local length = math.floor(percentage / (100 / max_length))
  return string.format(' %s%% %s%s', percentage, string.rep('━', length), string.rep('·', max_length - length))
end

---@param str string
---@param len integer
---@return string
function M.truncate(str, len)
  if vim.fn.strcharlen(str) > len then
    return vim.fn.strcharpart(str, 0, len - 1) .. M.ellipsis
  else
    return str
  end
end

M.checkbox = {
  check = '󱓻',
  dots = '󱨇',
  close = '󱓼',
}

M.status = {
  success = '',
  failure = '',
  running = '',
  canceled = '',
}

M.winbar_sep = {
  path = ' ',
  context = '  ',
}

M.chevron = {
  right = '',
  down = '',
}

M.kind = {
  Text = '',
  String = '',
  Number = '',
  Boolean = '',
  File = '',
  Folder = '',
  Method = '',
  Function = '',
  Constructor = '',
  Variable = '',
  Constant = '',
  Class = '',
  Struct = '',
  Object = '',
  Interface = '',
  Unit = '',
  Package = '',
  Module = '',
  Namespace = '',
  Array = '',
  Keyword = '',
  Snippet = '',
  Color = '',
  Reference = '',
  Enum = '',
  EnumMember = '',
  Value = '',
  Field = '',
  Property = '',
  Event = '',
  Operator = '',
  TypeParameter = '',
}

return M
