require'nvim-tree'.setup {}

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>n', ':NvimTreeFindFile<CR>', opts)

vim.cmd("command OffsetNvimTree :lua require('gersondev.nvim-tree-offset').toggle_nvim_tree_offset()")

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<C-n>', ':OffsetNvimTree<CR>', opts)

