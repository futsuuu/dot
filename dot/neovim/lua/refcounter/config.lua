local kind = vim.lsp.protocol.SymbolKind

---@class refcounter.Config
local M = {}

M.highlight = 'LspInlayHint'

M.update_delay = 300

M.target_kind = {
  kind.Function,
  kind.Method,
  kind.Constructor,
  kind.Interface,
  kind.Enum,
  kind.Struct,
  kind.Class,
}

M.parent_kind = {
  kind.Interface,
  kind.Struct,
  kind.Class,
  kind.Namespace,
  kind.Module,
  kind.Object,
  kind.Package,
}

---@param symbol lsp.DocumentSymbol
---@param ref_locations lsp.Location[]
---@return string?
function M.format(symbol, ref_locations) ---@diagnostic disable-line: unused-local
  local refs = #ref_locations
  if refs == 0 then
    return
  end

  return refs .. ' reference' .. (refs > 1 and 's' or '')
end

return M
