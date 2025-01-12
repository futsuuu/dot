local stdpath = require('rc.utils').stdpath

---@return string
local function get_config_dir()
  local link = vim.uv.fs_readlink(stdpath.config)
  local r
  if link then
    r = link
  else
    r = stdpath.config
  end
  return vim.fs.normalize(r)
end

---@return string?
local function get_plugin_name()
  local buf_path = vim.fn.expand('%:p')
  ---@cast buf_path string
  buf_path = vim.fs.normalize(buf_path, { expand_env = false })
  if buf_path:match(get_config_dir()) then
    return
  end
  local matched = buf_path:match('/lua/.+%.lua$') ---@type string?
  if matched then
    return vim.split(matched:gsub('%.lua$', ''), '/', { trimempty = true })[2]
  end
end

local plugin_name = get_plugin_name()
if not plugin_name then
  return
end

local function reload()
  for modname, _ in pairs(package.loaded) do
    ---@cast modname string
    if modname:match('^' .. plugin_name .. '%.') or modname == plugin_name then
      package.loaded[modname] = nil
      print('reset module:', modname)
    end
  end
end

vim.api.nvim_buf_create_user_command(0, 'ResetPlugin', reload, {})
