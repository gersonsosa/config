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

-- Have packer use a popup window
packer.init {
  max_jobs = 50,
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
    prompt_border = "rounded", -- Border style of prompt popups.
  },
}

return packer.startup(function(use)
  use 'wbthomason/packer.nvim' -- install packer
  use 'nvim-lua/plenary.nvim' -- required by many

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
    'nvim-telescope/telescope.nvim',
    requires = 'nvim-lua/plenary.nvim'
  }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'natecraddock/telescope-zf-native.nvim'
  use { 'nvim-telescope/telescope-ui-select.nvim' }
  use { 'nvim-telescope/telescope-frecency.nvim', requires = { "kkharji/sqlite.lua" } }

  -- LSP
  use 'neovim/nvim-lspconfig'
  use "jose-elias-alvarez/null-ls.nvim"
  use 'lewis6991/impatient.nvim'
  use { "folke/trouble.nvim", requires = "nvim-tree/nvim-web-devicons" }

  -- auto completion
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-vsnip" },
      { "hrsh7th/vim-vsnip" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-buffer" },
    },
  })

  use 'mfussenegger/nvim-dap'
  use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'nvim-treesitter/nvim-treesitter-context'

  use {
    'nvim-tree/nvim-tree.lua',
    requires = { 'nvim-tree/nvim-web-devicons' }
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons' }
  }

  -- greeter
  use {
    "goolord/alpha-nvim",
    config = function()
      require 'alpha'.setup(require 'alpha.themes.dashboard'.config)
    end
  }

  use { "akinsho/toggleterm.nvim", tag = '*', config = function()
    require("toggleterm").setup { open_mapping = [[<c-\>]] }
  end }

  use 'tpope/vim-eunuch'

  use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
  use 'lewis6991/gitsigns.nvim'
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
  use { 'ruifm/gitlinker.nvim', requires = 'nvim-lua/plenary.nvim' }
  use {
    'pwntester/octo.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require "octo".setup()
    end
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
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  })
  use 'numToStr/Comment.nvim'
  use 'rizzatti/dash.vim'
  use 'ojroques/nvim-osc52'

  use {
    'rmagatti/auto-session',
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      }
    end
  }

  use 'fatih/vim-go'
  use 'mfussenegger/nvim-jdtls'
  use { 'scalameta/nvim-metals', requires = "nvim-lua/plenary.nvim" }

  -- Coloschemes
  use 'folke/tokyonight.nvim'
  use { "catppuccin/nvim", as = "catppuccin" }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
