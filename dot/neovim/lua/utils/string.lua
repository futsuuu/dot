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

---@param s string
function string.ignorecase_pattern(s)
  local r = ''
  for _, char in ipairs(s:split '') do
    r = r .. '[' .. char:upper() .. char:lower() .. ']'
  end
  return r
end

---@param s string
---@param from string
---@param to string
function string.replace(s, from, to)
  local r ---@type string

  while true do
    local str = r or s
    local first, last = str:find(from, nil, true)
    if not (first and last) then
      break
    end

    r = str:sub(1, first - 1) .. to .. str:sub(last + 1, str:len())
  end

  return r or s
end
