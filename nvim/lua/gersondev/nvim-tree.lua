local f = require "gersondev.functions"
local map = f.map

require 'nvim-tree'.setup {
  view = {
    adaptive_size = true
  }
}

map('n', '<leader>n', ':NvimTreeFindFile<CR>', { desc = "Find file in tree" })
map('n', '<C-n>', ':NvimTreeToggle<CR>', { desc = "Toggle tree" })
map('n', '<leader>r', ':NvimTreeRefresh<CR>', { desc = "Refresh tree" })
