return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' }
    }
  }

  use 'neovim/nvim-lspconfig'

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

  -- tpope plugins because this deserves a special section
  use 'tpope/vim-eunuch'
  use 'tpope/vim-surround'
  use 'tpope/vim-vinegar'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-obsession'
  use 'tpope/vim-unimpaired'

  use 'airblade/vim-gitgutter'
  use 'mattn/gist-vim'
  use 'nathanaelkane/vim-indent-guides'

  use 'rizzatti/dash.vim'

  use 'fatih/vim-go'
  use 'mfussenegger/nvim-jdtls'

  use { 'dracula/vim', as = 'dracula' }

  use 'folke/tokyonight.nvim'

end)
