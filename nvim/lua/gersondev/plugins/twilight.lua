return {
  "folke/twilight.nvim",
  opts = {
    expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
      "function",
      "method",
    },
  }
}
