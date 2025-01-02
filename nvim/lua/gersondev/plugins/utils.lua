return {
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
    keys = {
      { "gc", "gb", mode = { "n", "v" } },
    },
  },
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({})
    end,
    keys = { { "ys" }, { "S", mode = "v" } },
    event = "InsertEnter",
  },
  { "ojroques/nvim-bufdel", event = "VeryLazy" },
  { "mbbill/undotree", cmd = { "UndotreeFocus", "UndotreeShow", "UndotreeToggle" } },
  {
    "tpope/vim-eunuch",
    cmd = { "Remove", "Delete", "Copy", "Duplicate", "Mkdir", "Cfind", "Lfind" },
  },
  {
    "tpope/vim-fugitive",
    cmd = "G",
    keys = "<leader>gs",
    config = function()
      vim.keymap.set("n", "<leader>gs", vim.cmd.G, { desc = "Open fugitive" })
    end,
  },
  {
    "codethread/qmk.nvim",
    lazy = true,
    opts = {
      name = "LAYOUT_split_3x5_2",
      layout = {
        "x x x x _ _ x x x x",
        "x x x x _ _ x x x x",
        "x x x x _ _ x x x x",
        "_ _ _ x x x x _ _ _",
      },
    },
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = {
        -- Options related to the notification window and buffer
        window = {
          winblend = 0, -- Background color opacity in the notification window
        },
      },
    },
  },
  {
    "fei6409/log-highlight.nvim",
    opts = {},
  },
}
