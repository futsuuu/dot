local M = {}

---Path separator
---@return string
function M.path_sep()
  return package.config:sub(1, 1)
end

---List segments
---@param directory string
---@return string[]
function M.ls(directory)
  local uv = vim.loop
  local dir = uv.fs_scandir(directory)
  if dir == nil then
    error('Cannot read directory `' .. directory .. '`', 2)
    return {}
  end
  local items = {}
  repeat
    local name, _ = uv.fs_scandir_next(dir)
    if name then
      table.insert(items, name)
    end
  until not name
  return items
end

---Check parent directories have specific items
---@param items string | string[]
---@return string?
function M.search_parent(items)
  local function join_to_path(path)
    local str = table.concat(path, M.path_sep())
    if M.path_sep() == '/' then
      str = '/' .. str
    end
    return str
  end

  if type(items) == 'string' then
    items = { items }
  end

  local path = vim.fn.expand('%:p'):split '/\\'
  if #path == 0 then
    return
  end

  while #path > 0 do
    table.remove(path)
    local current_dir = join_to_path(path)
    local list = M.ls(current_dir)

    for _, v in ipairs(items) do
      ---@type string[]
      local filtered_items = vim.tbl_filter(function(value)
        return value == v
      end, list)

      if #filtered_items == 1 then
        return current_dir .. M.path_sep() .. filtered_items[1]
      end
    end
  end
end

return M
