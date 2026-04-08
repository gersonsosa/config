return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  keys = {
    {
      "<leader>dv",
      function()
        if next(require("diffview.lib").views) == nil then
          vim.cmd([[DiffviewOpen]])
        else
          vim.cmd([[DiffviewClose]])
        end
      end,
      desc = "Smart Find Files",
    },
    {
      "<leader>df",
      function()
        if next(require("diffview.lib").views) == nil then
          vim.cmd([[DiffviewFileHistory %]])
        else
          vim.cmd([[DiffviewClose]])
        end
      end,
      desc = "Smart Find Files",
    },
  },
}
