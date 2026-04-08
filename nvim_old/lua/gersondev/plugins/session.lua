return {
  "folke/persistence.nvim",
  event = "BufReadPre", -- this will only start session saving when an actual file was opened
  opts = {
    dir = vim.fn.stdpath("state") .. "/sessions/", -- directory where session files are saved
    -- Set to 0 to always save
    need = 1,
    branch = true, -- use git branch to save session
  },
  keys = {
    {
      "<leader>qs",
      function()
        require("persistence").load()
      end,
    },
    {
      "<leader>qS",
      function()
        require("persistence").select()
      end,
    },
    {
      "<leader>ql",
      function()
        require("persistence").load({ last = true })
      end,
    },
    {
      "<leader>qd",
      function()
        require("persistence").stop()
      end,
    },
  },
}
