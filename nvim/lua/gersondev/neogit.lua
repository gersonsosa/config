local neogit = require("neogit")
neogit.setup {}

local f = require("gersondev.functions")
local map = f.map

map("n", "<leader>gs", function ()
  neogit.open()
end)
map("n", "<leader>gj", "<cmd>diffget //3<CR>")
map("n", "<leader>gf", "<cmd>diffget //2<CR>")
map("n", "<leader>ga", "<cmd>!git fetch --all<CR>")

