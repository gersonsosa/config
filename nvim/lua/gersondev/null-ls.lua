local n = require("null-ls")
n.setup {
  sources = {
    n.builtins.formatting.black,
    n.builtins.diagnostics.flake8,
    n.builtins.formatting.jq
  }
}
