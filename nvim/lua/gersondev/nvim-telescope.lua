vim.keymap.set("n", "<leader>mc", [[<cmd>lua require("telescope").extensions.metals.commands()<CR>]],
  { desc = 'Show metals commands', noremap = true })

local actions = require("telescope.actions")
require('telescope').setup {
  prompt_prefix = "❯",
  mappings = {
    n = {
      ["f"] = actions.send_to_qflist,
    },
  },
}
