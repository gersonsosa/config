local M = {}

local map = require "gersondev.common.functions".map

M.setup_lsp_keymap = function(_, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  map("n", "gD", [[<cmd>lua vim.lsp.buf.declaration()<CR>]], { buffer = bufnr })
  map('n', 'gd', [[<cmd>lua vim.lsp.buf.definition()<CR>]], { buffer = bufnr })
  map('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { buffer = bufnr })
  map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { buffer = bufnr })
  map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { buffer = bufnr })
  map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { buffer = bufnr })
  map('n', '<leader>h', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { buffer = bufnr })
  map('n', '<leader>wl',
    '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', { buffer = bufnr })
  map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { buffer = bufnr })
  map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { buffer = bufnr })
  map('n', '<leader>cl', '<cmd>lua vim.lsp.codelens.run()<CR>',
    { desc = 'Run code lens', buffer = bufnr })
  map('n', '<leader>fm', function() vim.lsp.buf.format() end, { buffer = bufnr })

  -- Telescope mappings
  local function telescope_lsp_doc_symbols()
    local status_ok, telescope_builtin = pcall(require, "telescope.builtin")
    if not status_ok then
      print("Couln't load telescope, is it installed?")
    end
    telescope_builtin.lsp_document_symbols()
  end

  map("n", "<leader>dS", telescope_lsp_doc_symbols, { desc = 'List document symbols', buffer = bufnr })
end

return M
