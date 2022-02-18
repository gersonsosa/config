" require plugin lua settings
lua require('gersondev')

" Enable sane defaults
set number relativenumber
set clipboard=unnamed
set colorcolumn=80
set tabstop=2
set expandtab shiftwidth=2
set smarttab
set list listchars=tab:▸▸,trail:·
set noshowmode

" neovim teminal mode mappings
:tnoremap <Esc> <C-\><C-n>

" Disable EX mode
:nnoremap Q <Nop>

" telescope mappings
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" nvim tree mappings
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

syntax enable
filetype on
colorscheme dracula

