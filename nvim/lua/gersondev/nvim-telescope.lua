local f = require("gersondev.functions")
local map = f.map

local t = require('telescope')
t.setup {
  defaults = {
    path_display = { "shorten" },
    preview = {
      filesize_hook = function(filepath, bufnr, opts)
        local max_bytes = 10000
        local cmd = { "head", "-c", max_bytes, filepath }
        require('telescope.previewers.utils').job_maker(cmd, bufnr, opts)
      end
    }
  },
  prompt_prefix = "❯",
  mappings = {
    ["<M-q>"] = false
  },
  pickers = {
    find_files = { theme = "ivy" },
    git_files = { theme = "ivy" },
    buffers = { theme = "ivy" },
    oldfiles = { theme = "ivy" },
    frecency = { theme = "ivy" },
    live_grep = { theme = "dropdown" },
    grep_string = { theme = "dropdown" }
  },
}

t.load_extension('zf-native')
t.load_extension('ui-select')

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
