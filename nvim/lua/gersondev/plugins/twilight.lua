return {
  "folke/twilight.nvim",
  opts = {
    dimming = {
      alpha = 0.60,    -- amount of dimming
    },
    context = 15,      -- amount of lines we will try to show around the current line
    treesitter = true, -- use treesitter when available for the filetype
    -- treesitter is used to automatically expand the visible text,
    -- but you can further control the types of nodes that should always be fully expanded
    expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
      "function",
      "method",
      "table",
    },
    exclude = {}, -- exclude these filetypes
  }
}
