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
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = true,
    config = function()
      require("gersondev.rose-pine")
      vim.cmd [[colorscheme rose-pine]]
    end
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    -- lazy = true,
    config = function()
      require("gersondev.catpppuccin")
      vim.cmd([[colorscheme catppuccin]])
    end
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
    },
    config = function()
      require("tokyonight").setup({
        transparent = true,
      })
      vim.cmd [[colorscheme tokyonight]]
    end
  },
  {
    "rebelot/heirline.nvim",
    config = function() require "gersondev.heirline" end
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    cmd = { "Neotree" },
    config = function() require("gersondev.neo-tree") end
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "natecraddock/telescope-zf-native.nvim",
    },
    config = function() require("gersondev.nvim-telescope") end,
    cmd = { "Telescope" }
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function() require('gersondev.nvim-treesitter') end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      "nvim-treesitter/nvim-treesitter-textobjects",
    }
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup { open_mapping = [[<c-\>]] }
    end,
    cmd = "ToggleTerm",
    keys = { "<c-\\>" }
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    config = function()
      require('bqf').setup({
        preview = {
          auto_preview = false,
        }
      })
    end
  },
  {
    "Shatur/neovim-session-manager",
    config = function()
      local config = require('session_manager.config')
      require("session_manager").setup({
        autoload_mode = config.AutoloadMode.CurrentDir,
        autosave_ignore_dirs = { "~/", "~/Downloads" }, -- A list of directories where the session will not be autosaved.
      })
    end
  },
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
  { "ojroques/nvim-osc52",  event = "VeryLazy" },
  { "ojroques/nvim-bufdel", event = "VeryLazy" },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    opts = {
      debounce = 100,
      indent = { char = "" },
    },
    event = "InsertEnter",
  },
  { "mbbill/undotree",    cmd = { "UndotreeFocus", "UndotreeShow", "UndotreeToggle" } },
  { "tpope/vim-eunuch",   lazy = true },
  { "tpope/vim-fugitive", cmd = "G" },
  {
    'NeogitOrg/neogit',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function() require("gersondev.neogit") end,
    cmd = 'Neogit'
  },
  {
    'lewis6991/gitsigns.nvim',
    event = "BufRead",
    config = function() require('gersondev.gitsigns') end,
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
    event = "BufRead",
    config = function() require('gersondev.nvim-lsp') end
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufRead",
    config = function() require('gersondev.null-ls') end,
  },
  {
    "onsails/diaglist.nvim",
    config = function() require("diaglist").init() end,
    lazy = true,
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
      "hrsh7th/cmp-cmdline",
      "rcarriga/cmp-dap",
      "uga-rosa/cmp-dictionary",
      "onsails/lspkind.nvim",
    },
    config = function() require('gersondev.cmp') end,
  },
  { "mfussenegger/nvim-jdtls", ft = "java" },
  {
    "scalameta/nvim-metals",
    dependencies = "nvim-lua/plenary.nvim",
    ft = { "scala", "sbt" },
    config = function() require("gersondev.nvim-metals") end
  },
  {
    "mfussenegger/nvim-dap",
    config = function() require('gersondev.dap') end,
    lazy = true
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-dap" },
    config = function() require("gersondev.dap-ui") end,
    lazy = true
  },
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        width = 120,
        height = 0.80,
        options = {
          -- signcolumn = "no", -- disable signcolumn
          number = true,         -- disable number column
          relativenumber = true, -- disable relative numbers
          -- cursorline = false, -- disable cursorline
          -- cursorcolumn = false, -- disable cursor column
          -- foldcolumn = "0", -- disable fold column
          -- list = false, -- disable whitespace characters
        },
      },
      plugins = {
        tmux = { enabled = true },
        alacritty = {
          enabled = false,
          font = "24",
        },
      },
    },
    cmd = { "ZenMode" },
  },
  { 'stevearc/dressing.nvim',  event = "BufRead" },
  {
    "github/copilot.vim",
    config = function()
      -- Disable copilot by default, invoke with M+\
      local file_types = { rust = true, lua = true, fish = true }
      file_types["*"] = false
      vim.inspect(file_types)
      vim.g.copilot_filetypes = file_types
    end
  },
  { 'rizzatti/dash.vim', cmd = { "Dash", "DashKeywords" } },
}

require("lazy").setup(plugins)
