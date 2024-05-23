set showcmd
set mouse=a

set autoindent
set tabstop=4
set shiftwidth=4

set number
set linebreak
set ruler

set hlsearch
set smartcase

set autochdir
set history=1000
set autoread
set list listchars=tab:▸\ 
set wildmenu
set wildmode=longest:list,full

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

call plug#begin()

Plug 'preservim/nerdtree'
Plug 'rust-lang/rust.vim'

call plug#end()
