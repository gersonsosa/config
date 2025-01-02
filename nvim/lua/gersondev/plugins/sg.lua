return {
  "sourcegraph/sg.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  opts = {},
  lazy = true,
  enabled = function()
    return vim.fn.executable("node") == 1
  end,
}
