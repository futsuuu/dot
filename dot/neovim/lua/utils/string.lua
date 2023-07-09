---Split string
---@param s string
---@param with string
---@return string[]
function string.split(s, with)
  local substrings = {}
  if with == '' then
    for i = 1, #s do
      table.insert(substrings, s:sub(i, i))
    end
  else
    for substring in s:gmatch('[^' .. with .. ']+') do
      table.insert(substrings, substring)
    end
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
