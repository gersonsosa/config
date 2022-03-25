require'nvim-tree'.setup {}

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>n', ':NvimTreeFindFile<CR>', opts)

