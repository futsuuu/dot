local ui = require 'core.ui'

local ufo = require 'ufo'

vim.o.foldenable = true
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.opt.fillchars:append {
  fold = ' ',
  foldopen = ui.chevron.down,
  foldsep = ' ',
  foldclose = ui.chevron.right,
}

ufo.setup {
  close_fold_kinds = {},
  ---@type fun(bufnr: buffer, filetype: string, buftype: string): string[] | string
  provider_selector = function(bufnr, filetype, buftype)
    for _, v in ipairs { 'terminal' } do
      if v == buftype then
        return ''
      end
    end
    for _, v in ipairs { 'neo-tree', 'Neogit', 'help' } do
      if filetype:find(v) then
        return ''
      end
    end
    local status, parser = pcall(vim.treesitter.get_parser, bufnr)
    if status and parser then
      return { 'lsp', 'treesitter' }
    end
    return { 'lsp', 'indent' }
  end,
  fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = ('    %d lines '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
      local chunkText = chunk[1]
      local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if targetWidth > curWidth + chunkWidth then
        table.insert(newVirtText, chunk)
      else
        chunkText = truncate(chunkText, targetWidth - curWidth)
        local hlGroup = chunk[2]
        table.insert(newVirtText, { chunkText, hlGroup })
        chunkWidth = vim.fn.strdisplaywidth(chunkText)
        -- str width returned from truncate() may less than 2nd argument, need padding
        if curWidth + chunkWidth < targetWidth then
          suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
        end
        break
      end
      curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, 'UfoFoldedEllipsis' })
    return newVirtText
  end,
}

vim.keymap.set('n', 'zr', ufo.openFoldsExceptKinds)
vim.keymap.set('n', 'zm', ufo.closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
