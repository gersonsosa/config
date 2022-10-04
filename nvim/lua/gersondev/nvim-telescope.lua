local f = require "gersondev.functions"
local map = f.map

local actions = require("telescope.actions")
require('telescope').setup {
  defaults = {
    path_display = { "smart" }
  },
  prompt_prefix = "❯",
  mappings = {
    n = {
      ["f"] = actions.send_to_qflist,
    },
  },
  pickers = {
    find_files = {
      theme = "ivy",
    }
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    }
  }
}

require('telescope').load_extension('fzf')

map("n", "<leader>t", [[<cmd>Telescope<cr>]], { desc = "Show all telescope builtin" })
map("n", "<leader>ff", [[<cmd>Telescope find_files<cr>]], { desc = "Find files" })
map("n", "<leader>fg", [[<cmd>Telescope live_grep<cr>]], { desc = "Live grep" })
map("n", "<leader>fb", [[<cmd>Telescope buffers<cr>]], { desc = "Buffers" })
map("n", "<leader>fh", [[<cmd>Telescope oldfiles<cr>]], { desc = "Recently opened files" })
map("n", "<leader>hh", [[<cmd>Telescope help_tags<cr>]], { desc = "Search help tags" })
map("n", "<leader>fs", [[<cmd>Telescope grep_string<cr>]], { desc = "Grep selected string" })
