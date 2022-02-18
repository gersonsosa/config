return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use 'neovim/nvim-lspconfig'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    config = function() require'nvim-tree'.setup {} end
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- tpope plugins
  use 'tpope/vim-eunuch'
  use 'tpope/vim-surround'
  use 'tpope/vim-vinegar'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-obsession'
  use 'tpope/vim-unimpaired'

  use 'airblade/vim-gitgutter'
  use 'mattn/gist-vim'
  use 'nathanaelkane/vim-indent-guides'

  use {
    'fatih/vim-go',
    run = ':GoUpdateBinaries'
  }

  use 'arcticicestudio/nord-vim'
  use {'dracula/vim', as = 'dracula'}

end)
