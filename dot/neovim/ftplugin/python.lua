local env = vim.env

if not env.VIRTUAL_ENV then
  local venv = vim.fs.find({ 'venv', '.venv' }, {
    upward = true,
    stop = vim.loop.os_homedir(),
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
    type = 'directory',
  })

  if #venv > 0 then
    env.PATH = venv[1] .. (package.config:sub(1, 1) == '\\' and '/Scripts;' or '/bin:') .. env.PATH
  end
end
