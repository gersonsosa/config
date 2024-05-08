return {
  {
    'numToStr/Comment.nvim',
    config = function() require('Comment').setup() end,
    keys = { { "gc", "gb", mode = { "n", "v" } } },
  },
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({})
    end,
    keys = { { "ys" }, { "S", mode = "v" } },
    event = "InsertEnter",
  },
  {
    "ojroques/nvim-osc52",
    event = "VeryLazy",
    config = function()
      vim.keymap.set('n', '<leader>y', require('osc52').copy_operator, { expr = true })
      vim.keymap.set('x', '<leader>y', require('osc52').copy_visual)
    end,
  },
  { "ojroques/nvim-bufdel", event = "VeryLazy" },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    opts = {
      debounce = 100,
      indent = { char = "" },
    },
    --event = "InsertEnter",
    lazy = true
  },
  { "mbbill/undotree",      cmd = { "UndotreeFocus", "UndotreeShow", "UndotreeToggle" } },
  { "tpope/vim-eunuch",     lazy = true },
  { "tpope/vim-fugitive",   cmd = "G" },
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
    }
  },
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
      notification = {
        -- Options related to the notification window and buffer
        window = {
          winblend = 0, -- Background color opacity in the notification window
        },
      },
    },
  }
}
