local M = {
  bug = ' ',
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
  path = ' 󰿟 ',
  context = '  ',
}

M.chevron = {
  right = '',
  down = '',
}

M.kind = {
  Text = '󰦨',
  String = '󱀍',
  Number = '󰎠',
  Boolean = '',
  File = '󰈤',
  Folder = '󰷏',
  Method = '󰅲',
  Function = '󰅲',
  Constructor = '󰢻',
  Field = '󰓼',
  Variable = '󰆧',
  Constant = '󰭸',
  Class = '󱦜',
  Struct = '󱦜',
  Interface = '',
  Package = '󱈎',
  Module = '󱈎',
  Namespace = '󰘦',
  Object = '󰘦',
  Array = '󰨾',
  Property = '󰯠',
  Unit = '󰑭',
  Keyword = '󰷖',
  Snippet = '󰗀',
  Color = '󰸌',
  Reference = '󰌹',
  Enum = '󱍶',
  EnumMember = '󰌖',
  Value = '󰌖',
  Event = '󰈾',
  Operator = '󰆕',
  TypeParameter = '󰊄',
}

return M
