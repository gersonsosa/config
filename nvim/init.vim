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
set dictionary+=/usr/share/dict/words

" neovim teminal mode mappings
:tnoremap <Esc> <C-\><C-n>

" Disable EX mode
:nnoremap Q <Nop>

" telescope mappings
nnoremap <leader>t  <cmd>Telescope builtin<cr>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nmap <leader>gj :diffget //3<CR>
nmap <leader>gf :diffget //2<CR>
nmap <leader>gs :G<CR>

syntax enable
filetype on

