local status_ok, n = pcall(require, "null-ls")
if not status_ok then
  return
end

n.setup {
  sources = {
    n.builtins.code_actions.gitsigns,
    n.builtins.diagnostics.fish,
    n.builtins.diagnostics.ruff,
    n.builtins.formatting.jq,
  }
}
