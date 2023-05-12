local Path = require 'utils.path'

local M = {}

---List segments
---@param directory Utils.Path
---@return Utils.Path[]
function M.ls(directory)
  local uv = vim.loop
  local dir = uv.fs_scandir(directory:str())
  if dir == nil then
    error('Cannot read directory: ' .. directory, 2)
    return {}
  end
  local items = {}
  repeat
    local name, _ = uv.fs_scandir_next(dir)
    if name then
      table.insert(items, directory / name)
    end
  until not name
  return items
end

---Check parent directories have specific items
---@param items string | string[]
---@return Utils.Path?
function M.search_parent(items)
  if type(items) == 'string' then
    items = { items }
  end

  local path = Path.new '%:p'

  while path:len() > 0 do
    path = path:parent()
    local list = M.ls(path)

    for _, v in ipairs(items) do
      ---@type Utils.Path[]
      local filtered_items = vim.tbl_filter(
        ---@param value Utils.Path
        ---@return boolean
        function(value)
          return value:name() == v
        end,
        list
      )

      if #filtered_items == 1 then
        return filtered_items[1]
      end
    end
  end
end

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

return M
