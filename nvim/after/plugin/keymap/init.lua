local f = require("gersondev.common.functions")
local map = f.map

-- neovim teminal mode mappings
map("t", "<esc>", "<C-\\><C-n>")

-- copy to system cliboard, also on blink
map('n', '<leader>y', require('osc52').copy_operator, { expr = true })
map('x', '<leader>y', require('osc52').copy_visual)

-- move single lines
map("n", "<C-j>", [[<cmd>m .+1<cr>]], { desc = "Move line down" })
map("n", "<C-k>", [[<cmd>m .-2<cr>]], { desc = "Move line up" })

-- Mappings.lsp
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
map('n', '<leader>di', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = "Show diagnostic in a window" })
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { desc = "Go to prev diagnostic" })
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { desc = "Go to next diagnostic" })
map('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { desc = "Open diagnostics" })

-- plugin mappings
-- tree
map('n', '<leader>n', vim.cmd.NeoTreeReveal, { desc = "Find file in tree" })
map('n', '<C-n>', vim.cmd.NeoTreeFocusToggle, { desc = "Toggle tree" })

-- neogit
map("n", "<leader>gs", vim.cmd.Neogit, { desc = "Open neogit" })
map("n", "<leader>gh", "<cmd>diffget //3<CR>")
map("n", "<leader>gu", "<cmd>diffget //2<CR>")
map("n", "<leader>ga", "<cmd>!git fetch --all<CR>")

-- gitsigns
map("n", "<leader>gn", [[<cmd>Gitsigns next_hunk<cr>]], { desc = "Go to next git hunk" })
map("n", "<leader>gp", [[<cmd>Gitsigns prev_hunk<cr>]], { desc = "Go to previous git hunk" })
map("n", "<leader>gb", [[<cmd>Gitsigns toggle_current_line_blame<cr>]], { desc = "Toggle line blame" })
map("n", "<leader>gd", [[<cmd>Gitsigns diffthis<cr>]], { desc = "Diff current buffer" })

-- dap-ui
map("n", "<leader>dq", [[<cmd>lua require("dapui").close()<cr>]], { desc = "Close dap ui" })
map("n", "<leader>dl", [[<cmd>lua require("dap").run_last()<cr>]], { desc = "Run last" })
map("n", "<leader>du", [[<cmd>lua require("dapui").toggle()<cr>]], { desc = "Toggle dap ui" })
map("n", "<leader>de", [[<cmd>lua require("dapui").eval()<cr>]], { desc = "Evaluate expression" })
map("n", "<leader>df", [[<cmd>lua require("dapui").float_element()<cr>]], { desc = "List float elements" })

-- telescope
map("n", "<leader>t", vim.cmd.Telescope, { desc = "Show all telescope builtin" })
map("n", "<leader>ff", [[<cmd>Telescope find_files<cr>]], { desc = "Find files" })
map("n", "<leader>gg", [[<cmd>Telescope git_files<cr>]], { desc = "Find git files" })
map("n", "<leader>fg", [[<cmd>Telescope live_grep<cr>]], { desc = "Live grep" })
map("n", "<leader>fb", [[<cmd>Telescope buffers<cr>]], { desc = "Buffers" })
map("n", "<leader>fh", [[<cmd>Telescope oldfiles only_cwd=true<cr>]], { desc = "Recently opened files" })
map("n", "<leader>hh", [[<cmd>Telescope help_tags<cr>]], { desc = "Search help tags" })
map("n", "<leader>tr", [[<cmd>Telescope resume<cr>]], { desc = "Resume last telescope prompt" })
map("n", "<leader>wg", [[<cmd>Telescope grep_string<cr>]], { desc = "Grep selected string" })
map("x", "<leader>wg", function()
    local status_ok, builtin = pcall(require, "telescope.builtin")
    if not status_ok then
      print("ERROR: couldn't load telescope")
      return
    end

    builtin.grep_string({ search = require("gersondev.common.functions").get_visual_text() })
  end,
  { desc = "Grep selected string" })

-- zen mode
map("n", "<leader>z", vim.cmd.ZenMode)

map("n", "<leader>e", [[:e <c-r>=expand("%:p:h") . "/" <cr>]], { desc = "Set command to expand to current file dir" })

map("n", "<leader>q", [[:%bd | norm <C-o><cr>]], { desc = "Delete all buffers but the current one" })
map("n", "<leader>qq", vim.cmd.BufDelOthers, { desc = "Delete all buffers but the current one" })

map("n", "<leader>wx", function() require('diaglist').open_all_diagnostics() end, { desc = "Open all diagnostics" })
map("n", "<leader>dx", function() require('diaglist').open_buffer_diagnostics() end, { desc = "Open buffer diagnostics" })

-- testing these out
map("n", "<leader>c", "<cmd>noh<cr>", { desc = "Clear highlights" })
map("i", "<C-c>", "<Esc>")
map("x", "<leader>p", [["_dP]], { desc = "Paste over selected text" })

map("n", "[c", function()
  require("treesitter-context").go_to_context()
  -- center the screen with zz
end, { desc = "Go to previous context" })

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

map("n", "J", "mzJ`z")
-- scroll with zz to center screen
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "<C-k>", "<cmd>cnext<CR>zz")
map("n", "<C-j>", "<cmd>cprev<CR>zz")
map("n", "<leader>k", "<cmd>lnext<CR>zz")
map("n", "<leader>j", "<cmd>lprev<CR>zz")
