" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-eunuch'
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-signify'
Plug 'mattn/gist-vim'
Plug 'fatih/vim-go'
Plug 'jodosha/vim-godebug'
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'justinmk/vim-dirvish'
Plug 'arcticicestudio/nord-vim'

" PlugInstall and PlugUpdate will clone fzf in ~/.fzf and run install script
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  " Both options are optional. You don't have to install fzf in ~/.fzf
  " and you don't have to run install script if you use fzf only in Vim.
Plug 'junegunn/fzf.vim'


" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Enable sane defaults
set number
set relativenumber
set hidden
set shiftwidth=0
set tabstop=4
set expandtab

" Copy to clipboard
vnoremap  <leader>y  "*y
nnoremap  <leader>Y  "*yg_
nnoremap  <leader>y  "*y
nnoremap  <leader>yy  "*yy

" Paste from clipboard
nnoremap <leader>p "*p
nnoremap <leader>P "*P
vnoremap <leader>p "*p
vnoremap <leader>P "*P

" Terminal mode mappings
tnoremap <Esc> <C-\><C-n>

" Disable EX mode
:nnoremap Q <Nop>

" Theme
" if (has("termguicolors"))
    let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
" endif
set t_Co=256
set background=dark

syntax enable
colorscheme nord
