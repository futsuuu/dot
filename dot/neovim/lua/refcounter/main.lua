local api = vim.api
local lsp = vim.lsp
local uv = vim.uv or vim.loop
local ms = lsp.protocol.Methods

local utils = require 'utils'
local params = require 'refcounter.params'
local config = require 'refcounter.config'
local VirtLine = require 'refcounter.virt_line'

local ns = api.nvim_create_namespace 'refcounter'

---@class refcounter.Main
---@field buf buffer
---@field running boolean
---@field cancel_funcs function[]
---@field virt_line refcounter.VirtLine
local M = {}

---@param buf buffer
---@return refcounter.Main?
function M.new(buf)
  if buf ~= api.nvim_get_current_buf() then
    return
  end

  ---@type refcounter.Main
  local self = setmetatable({}, { __index = M })

  self.buf = buf
  self.running = false
  self.cancel_funcs = {}
  self.virt_line = VirtLine.new(ns, self.buf)

  return self
end

function M:stop()
  if self.running then
    for _, fn in ipairs(self.cancel_funcs) do
      fn()
    end
  end
  self.cancel_funcs = {}
  self.running = false
end

function M:start()
  self.running = true
  self:get_document_symbols(function(symbols)
    ---@type table<lsp.DocumentSymbol, lsp.Location[]>
    local references = {}
    ---@type boolean[]
    local finished = {}

    for i, symbol in ipairs(symbols) do
      finished[i] = false

      self:get_references(symbol.selectionRange['end'], function(locations)
        references[symbol] = locations
        finished[i] = true
      end)
    end

    local timer = uv.new_timer()

    if not timer then
      self:stop()
      return
    end

    table.insert(self.cancel_funcs, 0, function()
      timer:stop()
      if not timer:is_closing() then
        timer:close()
      end
    end)

    timer:start(
      0,
      config.update_delay,
      vim.schedule_wrap(function()
        if #symbols ~= 0 and vim.tbl_contains(finished, false) then
          return
        end

        self:show(references)
        if not timer:is_closing() then
          timer:close()
        end
        self.running = false
        self:stop()
      end)
    )
  end)
end

---@param symbols lsp.DocumentSymbol[]
---@param max_depth integer
---@return lsp.DocumentSymbol[]
function M:get_all_symbols(symbols, max_depth)
  local r = {}

  ---@param s lsp.DocumentSymbol[]
  ---@param depth integer
  local function _get_all_symbols(s, depth)
    for _, symbol in ipairs(s) do
      if self:is_target(symbol, false) then
        table.insert(r, symbol)
      end
      if max_depth > depth and symbol.children and self:is_target(symbol, true) then
        _get_all_symbols(symbol.children, depth + 1)
      end
    end
  end

  _get_all_symbols(symbols, 0)
  return r
end

---@param callback fun(symbols: lsp.DocumentSymbol[])
function M:get_document_symbols(callback)
  local method = ms.textDocument_documentSymbol
  if not utils.lsp.support_method(self.buf, method) then
    return
  end

  local cancel = lsp.buf_request_all(
    self.buf,
    method,
    params.document_symbol(self.buf),
    utils.lsp.get_all_results(
      ---@param results lsp.DocumentSymbol[][]
      function(results)
        ---@type lsp.DocumentSymbol[]
        local symbols = table.flatten(results, 1)
        callback(M:get_all_symbols(symbols, 2))
      end
    )
  )

  table.insert(self.cancel_funcs, cancel)
end

---@param position lsp.Position
---@param callback fun(locations: lsp.Location[])
function M:get_references(position, callback)
  local method = ms.textDocument_references
  if not utils.lsp.support_method(self.buf, method) then
    return
  end

  local cancel = lsp.buf_request_all(
    self.buf,
    method,
    params.references(self.buf, position),
    utils.lsp.get_all_results(function(results)
      callback(table.flatten(results, 1))
    end)
  )

  table.insert(self.cancel_funcs, cancel)
end

---@param references table<lsp.DocumentSymbol, lsp.Location[]>
function M:show(references)
  if not api.nvim_buf_is_valid(self.buf) then
    return
  end

  self.virt_line:del()

  for symbol, ref_locations in pairs(references) do
    local text = config.format(self.buf, symbol, ref_locations)
    if text then
      self.virt_line:set(symbol.range.start.line, text)
    end
  end
end

---@param symbol lsp.DocumentSymbol
---@param parent boolean
---@return boolean
function M:is_target(symbol, parent)
  local list
  if parent then
    list = config.parent_kind
  else
    list = config.target_kind
  end
  return vim.tbl_contains(list, symbol.kind)
end

return M
