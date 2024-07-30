local api = vim.api
local uv = vim.uv
local function normalize(path)
  path = vim.fs.normalize(path)
  if package.config:sub(1, 1) == '\\' and path:sub(2, 3) == ':/' then
    path = path:sub(1, 1):upper() .. path:sub(2)
  end
  return path
end

local hl = require 'rc.highlight'
local line = require 'rc.ui.line'
local ui = require 'rc.ui'

local HOME = normalize(uv.os_homedir() or '')
local RUNTIME = normalize(vim.env.VIMRUNTIME)

---@param bufnr number
---@return string
local function get_navic_info(bufnr)
  local status, navic = pcall(require, 'nvim-navic')
  if not status then
    return ''
  end

  return navic.get_location(nil, bufnr)
end

---@param bufnr number
local function diagnostics(bufnr)
  local severity = vim.diagnostic.severity
  local hl_map = {
    [severity.ERROR] = 'DiagnosticError',
    [severity.WARN] = 'DiagnosticWarn',
    [severity.INFO] = 'DiagnosticInfo',
    [severity.HINT] = 'DiagnosticHint',
  }
  local severities = {
    severity.HINT,
    severity.WARN,
    severity.ERROR,
  }
  local r = ' '
  for _, s in pairs(severities) do
    local count = #vim.diagnostic.get(bufnr, { severity = s })
    if count == 0 then
      r = r .. line.with_hl('󱓼 ', 'WinBar')
    else
      local level = math.min(20 + count * 8, 100)
      r = r
        .. line.with_hl(
          '󱓻 ',
          hl.ensure('WinBar' .. hl_map[s] .. level, function()
            return hl.get('Whitespace'):mix(hl_map[s], level)
          end).name
        )
    end
  end
  return r
end

---@param bufnr number
---@return string
local function get_icon(bufnr)
  local icon = require('clico').get {
    path = api.nvim_buf_get_name(bufnr),
    ft = api.nvim_get_option_value('filetype', { buf = bufnr }),
  }
  return line.with_hl(icon.icon, icon.hl) .. ' '
end

---@param bufnr number?
---@return string
local function get_winbar(bufnr)
  if not bufnr or not api.nvim_buf_is_loaded(bufnr) then
    return ''
  end
  local buftype = api.nvim_get_option_value('buftype', { buf = bufnr })
  if buftype == 'nofile' or buftype == 'terminal' then
    return ''
  end
  local file = normalize(api.nvim_buf_get_name(bufnr))
    :replace(normalize(uv.cwd() or ''), '')
    :replace(RUNTIME, '')
    :replace(HOME, '~')

  local path = file:split '/'

  if 0 < #path then
    local file_name = table.remove(path)
    table.insert(path, get_icon(bufnr) .. file_name)
  end

  local navic_info = get_navic_info(bufnr)

  local winbar = ' '
  winbar = winbar .. table.concat(path, ui.winbar_sep.path)

  if navic_info ~= '' then
    winbar = winbar .. ui.winbar_sep.context
    winbar = winbar .. navic_info
  end

  winbar = winbar .. '%=' .. diagnostics(bufnr)

  return winbar
end

local M = {}

function M.setup()
  hl.set { WinBar = hl.get('Whitespace'):mix('Normal', 40), WinBarNC = 'WinBar' }
  api.nvim_create_autocmd('BufRead', {
    pattern = '*',
    callback = function(ev)
      vim.opt_local.winbar = line.as_opt(get_winbar, tostring(ev.buf))
    end,
  })
  api.nvim_create_autocmd('DiagnosticChanged', {
    command = 'redrawstatus',
  })
end

return M
