local f = require("gersondev.functions")
local map = f.map

-- neovim teminal mode mappings
map("t", "<esc>", "<C-\\><C-n>")
map('n', '<leader>y', require('osc52').copy_operator, { expr = true })
map('x', '<leader>y', require('osc52').copy_visual)

-- move lines
map("n", "<C-j>", [[<cmd>m .+1<cr>]], { desc = "Move line down" })
map("n", "<C-k>", [[<cmd>m .-2<cr>]], { desc = "Move line up" })

-- map({ "v", "x" }, "<C-j>", [[<cmd>'<,'>m .+1<cr>gv=gv]], { desc = "Move line down" })
-- map({ "v", "x" }, "<C-k>", [[<cmd>'<,'>m .-1<cr>gv=gv]], { desc = "Move line up" })
