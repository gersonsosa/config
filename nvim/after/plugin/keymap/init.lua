local f = require("gersondev.functions")
local map = f.map

-- neovim teminal mode mappings
map("t", "<esc>", "<C-\\><C-n>")

-- copy to system cliboard, also on blink
map('n', '<leader>y', function() require('osc52').copy_operator() end, { expr = true })
map('x', '<leader>y', function() require('osc52').copy_visual() end)

-- move single lines
map("n", "<C-j>", [[<cmd>m .+1<cr>]], { desc = "Move line down" })
map("n", "<C-k>", [[<cmd>m .-2<cr>]], { desc = "Move line up" })

-- Mappings.lsp
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
map('n', '<leader>di', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = "Show diagnostic in a window" })
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { desc = "Go to prev diagnostic" })
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { desc = "Go to next diagnostic" })
map('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { desc = "Open diagnostics" })

-- plugin mappings
-- tree
map('n', '<leader>n', vim.cmd.NeoTreeRevealToggle, { desc = "Find file in tree" })
map('n', '<C-n>', vim.cmd.NeoTreeFocusToggle, { desc = "Toggle tree" })

-- neogit
map("n", "<leader>gs", vim.cmd.Neogit, { desc = "Open neogit" })
map("n", "<leader>gj", "<cmd>diffget //3<CR>")
map("n", "<leader>gf", "<cmd>diffget //2<CR>")
map("n", "<leader>ga", "<cmd>!git fetch --all<CR>")

-- gitsigns
map("n", "<leader>gn", [[<cmd>Gitsigns next_hunk<cr>]], { desc = "Go to next git hunk" })
map("n", "<leader>gp", [[<cmd>Gitsigns prev_hunk<cr>]], { desc = "Go to previous git hunk" })
map("n", "<leader>gb", [[<cmd>Gitsigns toggle_current_line_blame<cr>]], { desc = "Toggle line blame" })
map("n", "<leader>gd", [[<cmd>Gitsigns diffthis<cr>]], { desc = "Diff current buffer" })

-- dap
map("n", "<leader>du", [[<cmd>lua require("dapui").toggle()<cr>]], { desc = "Toggle dap ui" })
map("n", "<leader>de", [[<cmd>lua require("dapui").eval()<cr>]], { desc = "Evaluate expression" })
map("n", "<leader>df", [[<cmd>lua require("dapui").float_element()<cr>]], { desc = "Evaluate expression" })

-- trouble
map("n", "<leader>dx", vim.cmd.Trouble, { desc = "Show current buffer trouble" })
map("n", "<leader>xx", [[<cmd>Trouble workspace_diagnostics<cr>]], { desc = "Show current workspace trouble" })

-- telescope
map("n", "<leader>t", vim.cmd.Telescope, { desc = "Show all telescope builtin" })
map("n", "<leader>ff", [[<cmd>Telescope find_files<cr>]], { desc = "Find files" })
map("n", "<leader>gg", [[<cmd>Telescope git_files<cr>]], { desc = "Find git files" })
map("n", "<leader>fg", [[<cmd>Telescope live_grep<cr>]], { desc = "Live grep" })
map("n", "<leader>fb", [[<cmd>Telescope buffers<cr>]], { desc = "Buffers" })
map("n", "<leader>fh", [[<cmd>Telescope oldfiles only_cwd=true<cr>]], { desc = "Recently opened files" })
map("n", "<leader>hh", [[<cmd>Telescope help_tags<cr>]], { desc = "Search help tags" })
map("n", "<leader>wg", [[<cmd>Telescope grep_string<cr>]], { desc = "Grep selected string" })
map("x", "<leader>wg", [[
  <cmd>lua require("telescope.builtin")
            .grep_string({ search = require("gersondev.functions").get_visual_selection() })
  <cr>]], { desc = "Grep selected string" })
map("n", "<leader>tr", [[<cmd>Telescope resume<cr>]], { desc = "Resume last telescope prompt" })
map("n", "<leader>fr", [[<cmd>lua require('telescope').extensions.frecency.frecency({ workspace = 'CWD' })<cr>]],
  { desc = "Find files - frecency" })

map("n", "<leader>z", vim.cmd.ZenMode)

-- disregard the next this is a test
map("n", "<leader>pr", [[<cmd>Octo pr list elastic/cloud labels=Team:Journey/Onboarding<cr>]],
  { desc = "Get elastic cloud pr" })
