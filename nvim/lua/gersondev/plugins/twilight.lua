return {
  "folke/twilight.nvim",
  cmd = "Twilight",
  opts = {
    dimming = {
      alpha = 0.70, -- amount of dimming
    },
    context = 13, -- amount of lines we will try to show around the current line
    treesitter = true, -- use treesitter when available for the filetype
    expand = {
      "function",
      "method",
      "table",
    },
    exclude = {}, -- exclude these filetypes
  },
}
