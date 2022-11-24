local f = require("gersondev.functions")
local map = f.map
require("gersondev.lsp-mappings")

-- neovim teminal mode mappings
map("t", "<esc>", "<C-\\><C-n>")

map('n', '<leader>n', ':NvimTreeFindFile<CR>', { desc = "Find file in tree" })
map('n', '<C-n>', ':NvimTreeToggle<CR>', { desc = "Toggle tree" })

map('n', '<leader>y', require('osc52').copy_operator, { expr = true })
map('x', '<leader>y', require('osc52').copy_visual)

-- move single lines
map("n", "<C-j>", [[<cmd>m .+1<cr>]], { desc = "Move line down" })
map("n", "<C-k>", [[<cmd>m .-2<cr>]], { desc = "Move line up" })

-- plugin mappings
-- neogit
map("n", "<leader>gs", [[<cmd>Neogit<cr>]], { desc = "Open neogit" })
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
map("n", "<leader>dx", [[<cmd>Trouble<cr>]], { desc = "Show current buffer trouble" })
map("n", "<leader>xx", [[<cmd>Trouble workspace_diagnostics<cr>]], { desc = "Show current workspace trouble" })

map("n", "<leader>fr", [[<cmd>lua require('telescope').extensions.frecency.frecency({ workspace = 'CWD' })<cr>]],
  { desc = "Find files - frecency" })

local function get_visual_selection()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg('v')
  vim.fn.setreg('v', {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ''
  end
end

local t_built_in = require "telescope.builtin"

map("n", "<leader>t", [[<cmd>Telescope<cr>]], { desc = "Show all telescope builtin" })
map("n", "<leader>ff", [[<cmd>Telescope find_files<cr>]], { desc = "Find files" })
map("n", "<leader>gg", [[<cmd>Telescope git_files<cr>]], { desc = "Find git files" })
map("n", "<leader>fg", [[<cmd>Telescope live_grep<cr>]], { desc = "Live grep" })
map("n", "<leader>fb", [[<cmd>Telescope buffers<cr>]], { desc = "Buffers" })
map("n", "<leader>fh", [[<cmd>Telescope oldfiles only_cwd=true<cr>]], { desc = "Recently opened files" })
map("n", "<leader>hh", [[<cmd>Telescope help_tags<cr>]], { desc = "Search help tags" })
map("n", "<leader>wg", [[<cmd>Telescope grep_string<cr>]], { desc = "Grep selected string" })
map("x", "<leader>wg", function() t_built_in.grep_string({ search = get_visual_selection() }) end,
  { desc = "Grep selected string" })
map("n", "<leader>tr", [[<cmd>Telescope resume<cr>]], { desc = "Resume last telescope prompt" })

-- discard this hunk
map("n", "<leader>eo", [[<cmd>Octo pr list elastic/cloud labels=Team:Journey/Onboarding<cr>]],
  { desc = "Get elastic cloud pr" })
