local n = require("null-ls")
n.setup {
  sources = {
    n.builtins.formatting.jq
  }
}
