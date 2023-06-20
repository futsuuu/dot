local env = vim.env

if env.VIRTUAL_ENV then
  return
end

---@type string[]
local venv = vim.fs.find({ 'venv', '.venv' }, {
  upward = true,
  stop = vim.loop.os_homedir(),
  path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
  type = 'directory',
})

if #venv == 0 then
  return
end

---@type string, string
local virtual_env, path_sep

if package.config:sub(1, 1) == '\\' then
  virtual_env = venv[1] .. '/Scripts'
  path_sep = ';'
else
  virtual_env = venv[1] .. '/bin'
  path_sep = ':'
end

env.VIRTUAL_ENV = virtual_env
env.PATH = virtual_env .. path_sep .. env.PATH
