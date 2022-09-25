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
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use { 'nvim-telescope/telescope-ui-select.nvim' }

  -- LSP
  use 'neovim/nvim-lspconfig'
  use { "jose-elias-alvarez/null-ls.nvim" }

  -- auto completion
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-vsnip" },
      { "hrsh7th/vim-vsnip" },
      { "hrsh7th/cmp-path" },
    },
  })

  use 'mfussenegger/nvim-dap'
  use "Pocco81/DAPInstall.nvim"

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    }
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use {
    'romgrk/barbar.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' }
  }

  -- greeter
  use {
    "goolord/alpha-nvim",
    config = function()
      require 'alpha'.setup(require 'alpha.themes.dashboard'.config)
    end
  }

  use { "akinsho/toggleterm.nvim", tag = '*', config = function()
    require("toggleterm").setup {
      open_mapping = [[<c-\>]],
    }
  end }

  -- tpope plugins because this deserves a special section
  use 'tpope/vim-eunuch'
  use 'tpope/vim-surround'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-obsession'
  use 'tpope/vim-rhubarb'

  use 'airblade/vim-gitgutter'
  use 'mattn/gist-vim'
  use { 'lukas-reineke/indent-blankline.nvim', config = function()
    require("indent_blankline").setup {
      -- for example, context is off by default, use this to turn it on
      show_current_context = true,
      show_current_context_start = true,
    }
  end }

  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }

  use 'rizzatti/dash.vim'

  use { 'ojroques/nvim-osc52',
    config = function()
      vim.keymap.set('n', '<leader>y', require('osc52').copy_operator, { expr = true })
      vim.keymap.set('n', '<leader>yy', '<leader>Y', { remap = true })
      vim.keymap.set('x', '<leader>y', require('osc52').copy_visual)
    end
  }

  use 'fatih/vim-go'
  use 'mfussenegger/nvim-jdtls'
  use { 'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim" } }

  -- Coloschemes
  use { 'dracula/vim', as = 'dracula' }
  use 'folke/tokyonight.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
