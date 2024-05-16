local build = {}

function build.mason()
  local registry = require 'mason-registry'

  local packages = {
    'lua-language-server',
    'stylua',
    'selene',
    'efm',
  }

  local function i(depends, servers)
    if type(depends) == 'string' then
      depends = { depends }
    end
    if type(servers) == 'string' then
      servers = { servers }
    end
    for _, cmd in ipairs(depends) do
      if not vim.fn.executable(cmd) then
        return
      end
    end
    for _, server in ipairs(servers) do
      table.insert(packages, server)
    end
  end

  i('npm', { 'json-lsp', 'css-lsp', 'html-lsp', 'vtsls' })
  i('python', 'black')
  i({ 'python', 'npm' }, 'pyright')
  i('zig', 'zls')

  for _, pkg in ipairs(registry.get_installed_packages()) do
    if not vim.list_contains(packages, pkg.name) then
      pkg:uninstall()
    end
  end

  registry.refresh(function()
    for _, pkg_name in ipairs(packages) do
      local pkg = registry.get_package(pkg_name)
      if not pkg:is_installed() then
        pkg:install()
      end
    end
  end)
end

return build
