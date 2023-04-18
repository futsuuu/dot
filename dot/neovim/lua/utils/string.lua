---Split string
---@param s string
---@param with string
---@return string[]
function string.split(s, with)
  local substrings = {}
  for substring in s:gmatch('[^' .. with .. ']+') do
    table.insert(substrings, substring)
  end
  return substrings
end

---Join strings
---@param s string
---@param str_list string[]
---@return string
function string.join(s, str_list)
  return table.concat(str_list, s)
end
