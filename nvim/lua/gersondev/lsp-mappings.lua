local f = require "gersondev.functions"
local map = f.map

-- Mappings.lsp
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
map('n', '<leader>di', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = "Show diagnostic in a window" })
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { desc = "Go to prev diagnostic" })
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { desc = "Go to next diagnostic" })
map('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { desc = "Open diagnostics" })
