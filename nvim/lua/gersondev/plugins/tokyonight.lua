return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    require("tokyonight").setup({
      style = "storm",
      transparent = true,
      dim_inactive = true, -- dims inactive windows
    })
    vim.cmd([[colorscheme tokyonight]])
  end,
}
