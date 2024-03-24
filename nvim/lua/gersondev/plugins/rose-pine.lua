return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = true,
    config = function()
      require('rose-pine').setup({
        -- @usage 'main' | 'moon'
        dark_variant = 'moon',
        bold_vert_split = false,
        dim_nc_background = false,
        disable_background = true,
        disable_float_background = true,
        disable_italics = false,

        styles = {
          bold = true,
          italic = true,
          transparency = true,
        },

        --- @usage string hex value or named color from rosepinetheme.com/palette

        highlight_groups = {
          ColorColumn = { bg = 'rose' },
          -- Blend colours against the "base" background
          CursorLine = { bg = 'foam', blend = 10 },
          StatusLine = { fg = 'love', bg = 'none' },
          -- By default each group adds to the existing config.
          -- If you only want to set what is written in this config exactly,
          -- you can set the inherit option:
          Search = { bg = 'gold', inherit = false },
          -- Telescope colours are set separately
          TelescopeBorder = { fg = "highlight_high", bg = "none" },
          TelescopeNormal = { bg = "none" },
          TelescopePromptNormal = { bg = "base" },
          TelescopeResultsNormal = { fg = "subtle", bg = "none" },
          TelescopeSelection = { fg = "text", bg = "base" },
          TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
        }
      })
      vim.cmd [[colorscheme rose-pine]]
    end
  }
}
