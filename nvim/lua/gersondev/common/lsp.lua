local M = {}

local map = require "gersondev.common.functions".map

M.setup_lsp_keymap = function(_, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  map("n", "gD", [[<cmd>lua vim.lsp.buf.declaration()<CR>]],
    { desc = "Go to declaration", buffer = bufnr })
  map("n", "gd", [[<cmd>lua vim.lsp.buf.definition()<CR>]],
    { desc = "Go to definition", buffer = bufnr })
  map("n", "gy", [[<cmd>lua vim.lsp.buf.type_definition()<CR>]],
    { desc = "Go to type definition", buffer = bufnr })
  map("n", "gr", [[<cmd>lua vim.lsp.buf.references()<CR>]],
    { desc = "Show references", buffer = bufnr })
  map("n", "K", function() vim.lsp.buf.hover() end,
    { desc = "Hover", buffer = bufnr })
  map("n", "gi", [[<cmd>lua vim.lsp.buf.implementation()<CR>]],
    { desc = "Go to implementation", buffer = bufnr })
  map("n", "<leader>h", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]],
    { desc = "Pop signature help", buffer = bufnr })

  map("n", "<leader>wl",
    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
    { desc = "List workspace folders", buffer = bufnr })

  map("n", "<leader>cl", "<cmd>lua vim.lsp.codelens.run()<CR>",
    { desc = 'Run code lens', buffer = bufnr })
  map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>",
    { desc = "Execute code action", buffer = bufnr })
  map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>",
    { desc = "Rename object", buffer = bufnr })

  map("n", "<leader>fm", function() vim.lsp.buf.format() end,
    { desc = "Format", buffer = bufnr })

  -- Telescope mappings
  local function telescope_lsp_doc_symbols()
    local status_ok, telescope_builtin = pcall(require, "telescope.builtin")
    if not status_ok then
      vim.notify("Couln't load telescope, is it installed?", vim.log.levels.ERROR)
    end
    telescope_builtin.lsp_document_symbols()
  end

  map("n", "<leader>dS", telescope_lsp_doc_symbols, { desc = 'List document symbols', buffer = bufnr })
  map("n", "gdS", function() vim.lsp.buf.document_symbol() end,
    { desc = "List symbols", buffer = bufnr })
  map("n", "gwS", function() vim.lsp.buf.workspace_symbol() end,
    { desc = "List workspace symbols", buffer = bufnr })
end

return M
