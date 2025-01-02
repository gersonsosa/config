local ft = { "bash", "lua" }

return {
  "github/copilot.vim",
  cmd = "Copilot",
  ft = ft,
  config = function()
    -- use ft to get file_types for copilot
    local file_types = {}
    for _, v in ipairs(ft) do
      file_types[v] = true
    end
    -- Disable copilot by default, invoke with M+\
    file_types["*"] = false
    vim.g.copilot_filetypes = file_types
  end,
}
