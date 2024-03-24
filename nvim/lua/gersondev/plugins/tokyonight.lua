return {
  "folke/tokyonight.nvim",
  lazy = true,
  opts = {
  },
  config = function()
    require("tokyonight").setup({
      transparent = true,
      on_highlights = function(hl, c)
        local prompt = "#2d3149"
        hl.TelescopeNormal = {
          bg = 'none',
          fg = c.fg_dark,
        }
        hl.TelescopeBorder = {
          bg = 'none',
          fg = c.bg_dark,
        }
        hl.TelescopePromptNormal = {
          bg = 'none',
        }
        hl.TelescopePromptBorder = {
          bg = 'none',
          fg = prompt,
        }
        hl.TelescopePromptTitle = {
          bg = 'none',
          fg = prompt,
        }
        hl.TelescopePreviewTitle = {
          bg = 'none',
          fg = c.bg_dark,
        }
        hl.TelescopeResultsTitle = {
          bg = 'none',
          fg = c.bg_dark,
        }
      end,
    })
    vim.cmd [[colorscheme tokyonight]]
  end
}
