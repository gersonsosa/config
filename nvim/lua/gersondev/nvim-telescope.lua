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
}
