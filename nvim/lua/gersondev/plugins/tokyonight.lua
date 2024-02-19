return {
  "folke/tokyonight.nvim",
  lazy = true,
  opts = {
  },
  config = function()
    require("tokyonight").setup({
      transparent = true,
    })
    vim.cmd [[colorscheme tokyonight]]
  end
}
