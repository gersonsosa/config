local actions = require("telescope.actions")
require('telescope').setup {
  prompt_prefix = "❯",
  mappings = {
    n = {
      ["f"] = actions.send_to_qflist,
    },
  },
}
