local util = vim.lsp.util

local M = {}

---@param buf buffer
---@return lsp.DocumentSymbolParams
function M.document_symbol(buf)
  return {
    textDocument = util.make_text_document_params(buf),
  }
end

---@param buf buffer
---@param pos lsp.Position
---@return lsp.ReferenceParams
function M.references(buf, pos)
  return {
    textDocument = util.make_text_document_params(buf),
    position = pos,
    context = {
      includeDeclaration = false,
    },
  }
end

return M
