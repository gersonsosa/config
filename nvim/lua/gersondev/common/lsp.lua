local M = {}

M.setup_lsp_keymap = function(_, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set("n", "gD", [[<cmd>lua vim.lsp.buf.declaration()<CR>]],
    { desc = "Go to declaration", buffer = bufnr, nowait = true })
  vim.keymap.set("n", "gd", [[<cmd>lua vim.lsp.buf.definition()<CR>]],
    { desc = "Go to definition", buffer = bufnr, nowait = true })
  vim.keymap.set("n", "gy", [[<cmd>lua vim.lsp.buf.type_definition()<CR>]],
    { desc = "Go to type definition", buffer = bufnr })
  vim.keymap.set("n", "gr", [[<cmd>lua vim.lsp.buf.references()<CR>]],
    { desc = "Show references", buffer = bufnr })
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end,
    { desc = "Hover", buffer = bufnr })
  vim.keymap.set("n", "gi", [[<cmd>lua vim.lsp.buf.implementation()<CR>]],
    { desc = "Go to implementation", buffer = bufnr })
  vim.keymap.set("n", "<leader>h", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]],
    { desc = "Pop signature help", buffer = bufnr })
  vim.keymap.set("i", "<C-s>", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]],
    { desc = "Pop signature help", buffer = bufnr })

  vim.keymap.set("n", "<leader>wl",
    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
    { desc = "List workspace folders", buffer = bufnr })

  vim.keymap.set("n", "<leader>cl", "<cmd>lua vim.lsp.codelens.run()<CR>",
    { desc = 'Run code lens', buffer = bufnr })
  vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>",
    { desc = "Execute code action", buffer = bufnr })
  vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>",
    { desc = "Rename object", buffer = bufnr })

  vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end,
    { desc = "Format", buffer = bufnr })

  -- Telescope mappings
  local function telescope_lsp_doc_symbols()
    local status_ok, telescope_builtin = pcall(require, "telescope.builtin")
    if not status_ok then
      vim.notify("Couln't load telescope, is it installed?", vim.log.levels.ERROR)
    end
    telescope_builtin.lsp_document_symbols()
  end

  vim.keymap.set("n", "<leader>dS", telescope_lsp_doc_symbols, { desc = 'List document symbols', buffer = bufnr })
  vim.keymap.set("n", "gdS", function() vim.lsp.buf.document_symbol() end,
    { desc = "List symbols", buffer = bufnr })
  vim.keymap.set("n", "gwS", function() vim.lsp.buf.workspace_symbol() end,
    { desc = "List workspace symbols", buffer = bufnr })
end

return M
