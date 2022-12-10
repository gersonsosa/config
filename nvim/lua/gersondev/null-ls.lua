local n = require("null-ls")
n.setup {
  sources = {
    n.builtins.formatting.jq,
    n.builtins.code_actions.gitsigns
  }
}
