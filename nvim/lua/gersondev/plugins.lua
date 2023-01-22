local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  {
    "rebelot/heirline.nvim",
    config = function() require "gersondev.heirline" end
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function() require('gersondev.nvim-tree') end,
    cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeFindFileToggle", "NvimTreeFocus" }
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "natecraddock/telescope-zf-native.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function() require("gersondev.nvim-telescope") end,
    cmd = { "Telescope" }
  },
  {
    'nvim-treesitter/nvim-treesitter', build = ':TSUpdate',
    config = function() require('gersondev.nvim-treesitter') end
  },
  { 'nvim-treesitter/nvim-treesitter-context' },
  {
    "akinsho/toggleterm.nvim", version = "*",
    config = function()
      require("toggleterm").setup { open_mapping = [[<c-\>]] }
    end,
    cmd = "ToggleTerm",
    keys = { "<c-\\>" }
  },
  { 'kevinhwang91/nvim-bqf', ft = 'qf' },
  {
    'rmagatti/auto-session',
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
      }
    end
  },
  { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end, event = "VeryLazy" },
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({})
    end,
    event = "VeryLazy"
  },
  { "ojroques/nvim-osc52", lazy = true },
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require("indent_blankline").setup {
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true,
      }
    end,
    event = "VeryLazy",
  },
  { "mbbill/undotree", cmd = { "UndotreeFocus", "UndotreeShow", "UndotreeToggle" } },
  { "tpope/vim-eunuch", lazy = true },
  { "tpope/vim-fugitive", cmd = "G" },
  {
    'TimUntersberger/neogit',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function() require("gersondev.neogit") end,
    cmd = 'Neogit'
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function() require('gersondev.gitsigns') end,
    cmd = { 'Gitsigns' }
  },
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { "DiffviewOpen", "DiffviewFileHistory" }
  },
  {
    'ruifm/gitlinker.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function() require("gitlinker").setup { opts = { remote = nil } } end,
    keys = { [[<leader>gy]] }
  },
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function() require "octo".setup() end,
    cmd = 'Octo'
  },
  {
    'neovim/nvim-lspconfig',
    config = function() require('gersondev.nvim-lsp') end
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function() require('gersondev.null-ls') end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require('gersondev.trouble') end,
    cmd = "Trouble"
  },
  { "mfussenegger/nvim-jdtls", ft = "java" },
  {
    "scalameta/nvim-metals",
    dependencies = "nvim-lua/plenary.nvim",
    ft = { "scala", "sbt" },
    config = function() require("gersondev.nvim-metals") end
  },
  {
    "hrsh7th/nvim-cmp",
    -- load cmp on InsertEnter
    event = "InsertEnter",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "rcarriga/cmp-dap",
      "uga-rosa/cmp-dictionary",
    },
    config = function()
      require('gersondev.cmp')
    end,
  },
  { "mfussenegger/nvim-dap", lazy = true },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-dap" },
    config = function() require("gersondev.dap") end,
    lazy = true
  },
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup({
        window = {
          backdrop = 1,
          width = 0.85,
        },
      })
    end,
    cmd = { "ZenMode" },
  },
  { 'rizzatti/dash.vim', cmd = { "Dash", "DashKeywords" } },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = true,
    config = function()
      require("gersondev.rose-pine")
    end
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    config = function()
      require("gersondev.catpppuccin")
    end
  },
  { "folke/tokyonight.nvim", lazy = true, }
}

require("lazy").setup(plugins)
