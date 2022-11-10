require("trouble").setup {
  position = "bottom",
  mode = "document_diagnostics",
  auto_preview = false,
}

local f = require("gersondev.functions")
local map = f.map

map("n", "<leader>dx", [[<cmd>Trouble<cr>]], { desc = "Show current buffer trouble" })
map("n", "<leader>xx", [[<cmd>Trouble workspace_diagnostics<cr>]], { desc = "Show current workspace trouble" })
