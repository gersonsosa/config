" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'

Plug 'airblade/vim-gitgutter'
Plug 'mattn/gist-vim'

Plug 'neovim/nvim-lspconfig'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'nathanaelkane/vim-indent-guides'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'itchyny/lightline.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'ryanoasis/vim-devicons'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" require plugin lua settings
lua require('gersondev')

" Enable sane defaults
set number
set relativenumber
set hidden
set shiftwidth=0
set tabstop=2
set expandtab
set autoindent
set updatetime=300

set noshowmode

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
:tnoremap <Esc> <C-\><C-n>

" Disable EX mode
:nnoremap Q <Nop>

syntax enable
filetype on
colorscheme nord

" netrw defaults
let g:netrw_winsize = 35
let g:netrw_liststyle = 3

let g:WebDevIconsOS = 'Darwin'

" lightline settings
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'deviconfiletype', 'filename', 'modified' ] ],
		  \   'right': [ [ 'lineinfo' ],
		  \            [ 'percent' ],
		  \            [ 'deviconfileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'tab_component_function': {
      \   'tabnum': 'LightlineTabWebDevIcon',
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'deviconfileformat': 'DevIconFileformat',
      \   'deviconfiletype': 'DevIconFiletype'
      \ },
      \ 'colorscheme': 'nord',
      \ }

function! LightlineTabWebDevIcon(n)
  let l:bufnr = tabpagebuflist(a:n)[tabpagewinnr(a:n) - 1]
  return WebDevIconsGetFileTypeSymbol(bufname(l:bufnr))
endfunction

function! DevIconFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! DevIconFileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

