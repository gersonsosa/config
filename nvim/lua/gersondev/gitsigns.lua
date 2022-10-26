local f = require "gersondev.functions"
local map = f.map

require('gitsigns').setup({
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 1000,
    ignore_whitespace = false,
  },
})

map("n", "<leader>gn", [[<cmd>Gitsigns next_hunk<cr>]], { desc = "Go to next git hunk" })
map("n", "<leader>gp", [[<cmd>Gitsigns prev_hunk<cr>]], { desc = "Go to previous git hunk" })
map("n", "<leader>gb", [[<cmd>Gitsigns toggle_current_line_blame<cr>]], { desc = "Toggle line blame" })
map("n", "<leader>gd", [[<cmd>Gitsigns diffthis<cr>]], { desc = "Diff current buffer" })
