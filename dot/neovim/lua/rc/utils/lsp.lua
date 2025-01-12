local M = {}

---@param on_attach fun(client: vim.lsp.Client, buffer: buffer)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      ---@diagnostic disable-next-line: param-type-mismatch
      on_attach(client, buffer)
    end,
  })
end

---@param buf buffer
---@param method string
function M.support_method(buf, method)
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

---Handler of vim.lsp.buf_request_all
---@param callback fun(results: any[])
function M.get_all_results(callback)
  ---@param results table<integer, { error: lsp.ResponseError, result: any }>
  return function(results)
    local ret = {}
    for _, result in pairs(results) do
      table.insert(ret, result.result)
    end
    callback(ret)
  end
end

return M
