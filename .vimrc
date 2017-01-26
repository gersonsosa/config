" .vimrc
if &compatible
  set nocompatible
endif
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim " path to dein.vim

call dein#begin(expand('~/.vim/dein'))

call dein#add('Shougo/dein.vim')
call dein#add('Shougo/neocomplete.vim')
call dein#add('tpope/vim-sensible')
call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
call dein#add('tpope/vim-fugitive')
call dein#add('vim-airline/vim-airline')
call dein#add('ryanoasis/vim-devicons')

call dein#add('sheerun/vim-polyglot')
call dein#add('Quramy/tsuquyomi')
call dein#add('Yggdroot/indentLine')
call dein#add('Wutzara/vim-materialtheme')
call dein#add('NLKNguyen/papercolor-theme')
call dein#add('mhartington/oceanic-next')
call dein#add('mhinz/vim-signify')

call dein#add('tpope/vim-surround')
call dein#add('ctrlpvim/ctrlp.vim')
call dein#add('Shougo/unite.vim')
call dein#add('scrooloose/nerdtree')

call dein#add('mattn/emmet-vim', {'on_ft': 'html'})
call dein#add('terryma/vim-multiple-cursors')
call dein#add('Chiel92/vim-autoformat')
call dein#add('ujihisa/unite-colorscheme')
call dein#add('Shougo/unite-outline')
call dein#add('honza/vim-snippets')
call dein#add('matthewsimo/angular-vim-snippets')
call dein#add('mattn/webapi-vim')
call dein#add('mattn/gist-vim')
call dein#add('KabbAmine/zeavim.vim')
call dein#add('gabesoft/vim-ags')
call dein#add('jeffkreeftmeijer/vim-numbertoggle')

call dein#end()

filetype plugin indent on

" VIM SETTINGS
  set showcmd   " display incomplete commands
  if has("vms")
      set nobackup    " do not keep a backup file, use versions instead
  else
      set backup      " keep a backup file (restore to previous version)
      set undofile    " keep an undo file (undo changes after closing)
      set backupdir=./.backup,~/.vim/tmp,.
      set directory=.,~/.vim/tmp,./.backup
  endif
  
  " Only do this part when compiled with support for autocommands.
  if has("autocmd")
      " Put these in an autocmd group, so that we can delete them easily.
      augroup vimrcEx
          au!
  
          " For all text files set 'textwidth' to 78 characters.
          autocmd FileType text setlocal textwidth=78
  
          " When editing a file, always jump to the last known cursor position.
          " Don't do it when the position is invalid or when inside an event handler
          " (happens when dropping a file on gvim).
          autocmd BufReadPost *
                      \ if line("'\"") >= 1 && line("'\"") <= line("$") |
                      \   exe "normal! g`\"" |
                      \ endif
  
      augroup END
  endif               " has("autocmd")
  
  set tabstop=4       " Number of spaces that a <Tab> in the file counts for.
  
  set shiftwidth=4    " Number of spaces to use for each step of (auto)indent.
  
  set expandtab       " Use the appropriate number of spaces to insert a <Tab>.
  " Spaces are used in indents with the '>' and '<' commands
  " and when 'autoindent' is on. To insert a real tab when
  " 'expandtab' is on, use CTRL-V <Tab>.
  set smarttab        " When on, a <Tab> in front of a line inserts blanks
  " according to 'shiftwidth'. 'tabstop' is used in other
  " places. A <BS> will delete a 'shiftwidth' worth of space
  " at the start of the line.
  set number          " Show line numbers.
  
  set ignorecase      " Ignore case in search patterns.
  
  set smartcase       " Override the 'ignorecase' option if the search pattern

" KEYBOARD MAPPINGS
  " CTRL-c copy to system clipboard
  vnoremap <C-c> "+y
  " No need for ex mode
  nnoremap Q <nop>
  nmap <leader>kk :bnext<CR>
  nmap <leader>jj :bprevious<CR>
  nmap <leader>T :enew<cr>
  noremap <leader>f :Autoformat<CR>

" OCEANIC NEXT Theme config
  syntax enable
  set t_Co=256
  colorscheme OceanicNext
  set background=dark
" VIM AIRLINE
  let g:airline#extensions#tabline#enabled = 1
  set hidden
  let g:airline#extensions#tabline#fnamemod = ':t'
  let g:airline#extensions#tabline#show_tab_nr = 1
  let g:airline_powerline_fonts = 1
  let g:airline_theme='oceanicnext'

" CTRLP
  let g:ctrlp_custom_ignore = {
              \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site|target)$',
              \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
              \}

  " Use the nearest .git directory as the cwd
  " This makes a lot of sense if you are working on a project that is in
  " version control. It also supports works with .svn, .hg, .bzr.
  let g:ctrlp_working_path_mode = 'r'

  " Use a leader instead of the actual named binding
  nmap <leader>p :CtrlP<cr>

  " Easy bindings for its various modes
  nmap <leader>bb :CtrlPBuffer<cr>
  nmap <leader>bm :CtrlPMixed<cr>

" Unite
  nnoremap <silent> <leader>c :Unite -auto-resize -start-insert -direction=botright colorscheme<CR>
  nnoremap <silent> <leader>u :call dein#update()<CR>
  nnoremap <leader>o :<C-u>Unite -no-split -buffer-name=outline -start-insert outline<cr>
