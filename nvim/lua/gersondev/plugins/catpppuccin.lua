return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  -- lazy = true,
  config = function()
    require("catppuccin").setup {
      flavour = "frappe", -- mocha, macchiato, frappe, latte
      transparent_background = true,
      integrations = {
        telescope = true,
        neogit = true,
        fidget = true,
        gitsigns = true,
        treesitter = true,
        treesitter_context = true,
        markdown = true,
        neotree = true,
        lsp_trouble = false,
        dap = {
          enabled = true,
          enable_ui = true,
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "bold" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "undercurl" },
            hints = { "underdouble" },
            warnings = { "underdashed" },
            information = { "underline" },
          },
          inlay_hints = {
            background = true,
          },

        },
        cmp = true,
        octo = true,
        diffview = true,
      }
    }

    vim.cmd([[colorscheme catppuccin]])
  end
}
