local fn = vim.fn

local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path
  }
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

packer.init {
  max_jobs = 50
}

return packer.startup(function(use)
  use 'wbthomason/packer.nvim' -- install packer
  use 'lewis6991/impatient.nvim'

  -- key bindings helper
  use { "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        plugins = {
          registers = true,
          presets = {
            -- adds help for operators like d, y, ... and registers them for motion / text object completion
            operators = true,
            -- adds help for motions
            motions = true,
            -- help for text objects triggered after entering an operator
            text_objects = true,
            -- default bindings on <c-w>
            windows = true,
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = false, -- bindings for prefixed with g
          },
        }
      }
    end
  }

  -- Telescope
  use {
    {
      'nvim-telescope/telescope.nvim',
      requires = {
        "nvim-lua/plenary.nvim",
        "natecraddock/telescope-zf-native.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
      },
      config = function() require("gersondev.nvim-telescope") end,
    },
    {
      "nvim-telescope/telescope-frecency.nvim",
      requires = "kkharji/sqlite.lua",
      after = "telescope.nvim",
      config = function()
        require("telescope").load_extension("frecency")
      end
    }
  }

  -- LSP
  use {
    {
      'neovim/nvim-lspconfig',
      config = function() require('gersondev.nvim-lsp') end
    },
    {
      "jose-elias-alvarez/null-ls.nvim",
      config = function() require('gersondev.null-ls') end,
      after = "nvim-lspconfig"
    },
    {
      "folke/trouble.nvim",
      requires = "nvim-tree/nvim-web-devicons",
      config = function() require('gersondev.trouble') end,
      cmd = "Trouble"
    }
  }

  -- auto completion
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      { "hrsh7th/cmp-path", after = "nvim-cmp" },
      { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
      { "rcarriga/cmp-dap", after = "nvim-cmp" },
      { "uga-rosa/cmp-dictionary" },
    },
    config = function() require('gersondev.cmp') end
  }

  use {
    { "mfussenegger/nvim-dap" },
    {
      "rcarriga/nvim-dap-ui",
      requires = "nvim-dap",
      after = "nvim-dap",
      config = function() require("gersondev.dap") end
    }
  }

  use {
    {
      'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
      config = function() require('gersondev.nvim-treesitter') end
    },
    { 'nvim-treesitter/nvim-treesitter-context' }
  }

  use {
    'nvim-tree/nvim-tree.lua',
    requires = 'nvim-tree/nvim-web-devicons',
    config = function() require('gersondev.nvim-tree') end
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = 'nvim-tree/nvim-web-devicons',
    config = function() require('gersondev.lualine-config') end
  }

  use { "akinsho/toggleterm.nvim", tag = '*', config = function()
    require("toggleterm").setup { open_mapping = [[<c-\>]] }
  end }

  use { 'tpope/vim-eunuch', opt = true }

  use {
    {
      'TimUntersberger/neogit',
      requires = 'nvim-lua/plenary.nvim',
      config = function() require("gersondev.neogit") end,
      cmd = 'Neogit'
    },
    {
      'lewis6991/gitsigns.nvim',
      config = function() require('gersondev.gitsigns') end,
      cmd = { 'GitSigns', 'Gitsigns' }
    },
    {
      'sindrets/diffview.nvim',
      requires = 'nvim-lua/plenary.nvim',
    },
    {
      'ruifm/gitlinker.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function() require("gitlinker").setup() end
    },
    {
      'pwntester/octo.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        'nvim-tree/nvim-web-devicons',
      },
      after = {
        'plenary.nvim',
        'telescope.nvim',
        'nvim-web-devicons',
      },
      config = function() require "octo".setup() end,
      cmd = 'Octo'
    }
  }

  use { 'lukas-reineke/indent-blankline.nvim', config = function()
    require("indent_blankline").setup {
      -- for example, context is off by default, use this to turn it on
      show_current_context = true,
      show_current_context_start = false,
    }
  end }

  use { 'kevinhwang91/nvim-bqf', ft = 'qf' }

  use({
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({})
    end
  })

  use { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end }
  use { 'rizzatti/dash.vim', cmd = { "Dash", "DashKeywords" } }
  use 'ojroques/nvim-osc52'

  use {
    'rmagatti/auto-session',
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
      }
    end
  }

  use { "fatih/vim-go", ft = "go" }
  use { "mfussenegger/nvim-jdtls", ft = "java" }
  use {
    "scalameta/nvim-metals",
    requires = "nvim-lua/plenary.nvim",
    ft = { "scala", "sbt" },
    config = function() require("gersondev.nvim-metals") end
  }

  -- Coloschemes
  use 'folke/tokyonight.nvim'
  use { "catppuccin/nvim", as = "catppuccin" }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
