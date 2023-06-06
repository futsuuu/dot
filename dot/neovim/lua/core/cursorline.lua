-- github.com/delphinus/auto-cursorline.nvim/blob/main/lua/auto-cursorline/main.lua

local STATUS_DISABLED = 0
local STATUS_CURSOR = 1
local STATUS_WINDOW = 2

local function on()
  vim.wo.cursorline = true
end

local function off()
  vim.wo.cursorline = false
end

local uv = vim.loop
local api = setmetatable({ _cache = {} }, {
  __index = function(self, name)
    if not self._cache[name] then
      local func = vim.api['nvim_' .. name]
      if func then
        self._cache[name] = func
      else
        error('Unknown api func: ' .. name, 2)
      end
    end
    return self._cache[name]
  end,
})

local M = {}

function M.new()
  return setmetatable({
    wait_ms = 300,
    status = STATUS_DISABLED,
    augroup_id = nil,
    timer = nil,
  }, { __index = M })
end

function M:setup(opt)
  opt = opt or {}
  if opt.wait_ms then
    self.wait_ms = opt.wait_ms
  end
  self:setup_events(opt.force)
  self.status = STATUS_CURSOR
  on()
end

function M:setup_events(force)
  if self.augroup_id and not force then
    return
  end
  self.augroup_id = api.create_augroup('auto-cursorline', {})

  local function create_au(events, method)
    api.create_autocmd(events, {
      group = self.augroup_id,
      desc = 'call auto-cursorline:' .. method .. '()',
      callback = function()
        if self:is_enabled() then
          self[method](self)
        end
      end,
    })
  end

  create_au({ 'CursorMoved', 'CursorMovedI' }, 'cursor_moved')
  create_au({ 'WinEnter' }, 'win_enter')
  create_au({ 'WinLeave' }, 'win_leave')
end

function M:cursor_moved()
  if self.status == STATUS_WINDOW then
    self.status = STATUS_CURSOR
    return
  end
  self:timer_stop()
  self.timer = vim.defer_fn(function()
    self.status = STATUS_CURSOR
    on()
  end, self.wait_ms)
  if self.status == STATUS_CURSOR then
    off()
    self.status = STATUS_DISABLED
  end
end

function M:win_enter()
  on()
  self.status = STATUS_WINDOW
  self:timer_stop()
end

function M:win_leave()
  off()
  self:timer_stop()
end

function M:timer_stop()
  if self.timer and uv.is_active(self.timer) then
    self.timer:stop()
    self.timer:close()
  end
end

function M:is_enabled()
  local enabled = true
  for _, v in ipairs { 'terminal' } do
    if vim.bo.buftype == v then
      enabled = false
      return
    end
  end
  for _, v in ipairs { 'TelescopePrompt', 'neo-tree', 'alpha', 'ddu-ff' } do
    if vim.bo.filetype == v then
      enabled = false
      return
    end
  end
  return enabled
end

local main = M.new()

main:setup()
