return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = { style = "moon", transparent = false, dim_inactive = true },
  config = function()
    vim.cmd([[colorscheme tokyonight]])
  end,
}
