return {
  "github/copilot.vim",
  config = function()
    -- Disable copilot by default, invoke with M+\
    local file_types = { rust = true, lua = true, fish = true }
    file_types["*"] = false
    vim.inspect(file_types)
    vim.g.copilot_filetypes = file_types
  end
}
