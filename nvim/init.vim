" require plugin lua settings
lua require('gersondev')

" Enable sane defaults
set number relativenumber
set clipboard+=unnamedplus
set colorcolumn=80
set tabstop=2
set expandtab shiftwidth=2
set smarttab
set list listchars=tab:▸▸,trail:·
set noshowmode
set timeoutlen=1500
set dictionary+=/usr/share/dict/words

" neovim teminal mode mappings
:tnoremap <Esc> <C-\><C-n>

" Disable EX mode
:nnoremap Q <Nop>

nmap <leader>gj :diffget //3<CR>
nmap <leader>gf :diffget //2<CR>
nmap <leader>gs :G<CR>
nmap <leader>gl :Gclog --oneline -20<CR>

set mouse=vi
syntax enable
filetype on

