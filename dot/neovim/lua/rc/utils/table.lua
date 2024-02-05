---Flatten array
---@param array any[]
---@param run_depth? integer
---@return any[]
function table.flatten(array, run_depth)
  local function flatten_list(arr, max_depth, current_depth)
    if type(arr) ~= 'table' or current_depth > max_depth then
      return { arr }
    end

    local result = {}
    for _, item in ipairs(arr) do
      local flat_item = flatten_list(item, max_depth, current_depth + 1)
      for _, sub_item in ipairs(flat_item) do
        table.insert(result, sub_item)
      end
    end

    return result
  end

  return flatten_list(array, run_depth or math.huge, 0)
end
