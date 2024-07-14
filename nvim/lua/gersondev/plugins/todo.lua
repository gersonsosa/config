return {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    -- local colors = require("catppuccin.palettes").get_palette "macchiato"
    local colors = require("tokyonight.colors").setup()
    require("todo-comments").setup({
      signs = true,
      keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "󰙨 ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      gui_style = {
        fg = "NONE", -- The gui style to use for the fg highlight group.
        bg = "bold", -- The gui style to use for the bg highlight group.
      },
      colors = {
        error = { colors.red, "DiagnosticError", "ErrorMsg" },
        warning = { colors.yellow, "DiagnosticWarn", "WarningMsg" },
        info = { colors.sapphire, "DiagnosticInfo" },
        hint = { colors.green, "DiagnosticHint" },
        default = { colors.sapphire, "Identifier" },
        test = { colors.maroon, "Identifier" },
      },
    })
  end,
}
