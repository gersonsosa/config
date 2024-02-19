-- neovim teminal mode mappings
vim.keymap.set("t", "<esc>", "<C-\\><C-n>")

vim.keymap.set("n", "<leader>c", "<cmd>noh<cr>", { desc = "Clear highlights" })
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over selected text" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- scroll down with zz to center screen
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>e", [[:e <c-r>=expand("%:p:h") . "/" <cr>]],
  { desc = "Set command to expand to current file dir" })

vim.keymap.set("n", "<leader>dA", [[:%bd | norm <C-o><cr>]], { desc = "Delete all buffers but the current one" })
vim.keymap.set("n", "<leader>dO", vim.cmd.BufDelOthers, { desc = "Delete all buffers but the current one" })

-- Mappings.diagnostics
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>di', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = "Show diagnostic in a window" })
vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { desc = "Go to prev diagnostic" })
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { desc = "Go to next diagnostic" })
vim.keymap.set('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { desc = "Open diagnostics" })

-- git related mappings
vim.keymap.set("n", "<leader>gh", "<cmd>diffget //3<CR>")
vim.keymap.set("n", "<leader>gu", "<cmd>diffget //2<CR>")
vim.keymap.set("n", "<leader>ga", "<cmd>!git fetch --all<CR>")

-- gitsigns
vim.keymap.set("n", "<leader>gn", [[<cmd>Gitsigns next_hunk<cr>]], { desc = "Go to next git hunk" })
vim.keymap.set("n", "<leader>gp", [[<cmd>Gitsigns prev_hunk<cr>]], { desc = "Go to previous git hunk" })
vim.keymap.set("n", "<leader>gb", [[<cmd>Gitsigns toggle_current_line_blame<cr>]], { desc = "Toggle line blame" })
vim.keymap.set("n", "<leader>gd", [[<cmd>Gitsigns diffthis<cr>]], { desc = "Diff current buffer" })

-- dap-ui
vim.keymap.set("n", "<leader>dq", [[<cmd>DapToggleRepl<cr>]], { desc = "Close dap ui" })
vim.keymap.set("n", "<leader>dl", [[<cmd>lua require("dap").run_last()<cr>]], { desc = "Run last" })
vim.keymap.set("n", "<leader>du", [[<cmd>lua require("dapui").toggle()<cr>]], { desc = "Toggle dap ui" })
vim.keymap.set("n", "<leader>de", [[<cmd>lua require("dapui").eval()<cr>]], { desc = "Evaluate expression" })
vim.keymap.set("n", "<leader>df", [[<cmd>lua require("dapui").float_element()<cr>]], { desc = "List float elements" })

-- telescope
