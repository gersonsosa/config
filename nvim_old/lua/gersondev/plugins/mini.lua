return {
  {
    "echasnovski/mini.icons",
    version = "*",
    opts = {},
  },
  {
    "echasnovski/mini.ai",
    version = "*",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      local spec_treesitter = require("mini.ai").gen_spec.treesitter
      require("mini.ai").setup({
        custom_textobjects = {
          F = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
          C = spec_treesitter({
            a = { "@class.outer", "@trait.outer", "@object.outer" },
            i = { "@class.inner", "@trait.inner", "@object.inner" },
          }),
        },
      })
    end,
  },
}
