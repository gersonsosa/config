return {
  "onsails/diaglist.nvim",
  keys = { "<leader>dx", "<leader>wx" },
  config = function()
    local status_ok, diaglist = pcall(require, "diaglist")
    if not status_ok then
      return
    end

    diaglist.init()

    vim.keymap.set("n", "<leader>wx", function() diaglist.open_all_diagnostics() end,
      { desc = "Open all diagnostics" })
    vim.keymap.set("n", "<leader>dx", function() diaglist.open_buffer_diagnostics() end,
      { desc = "Open buffer diagnostics" })
  end,
}
