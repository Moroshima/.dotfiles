set mouse=a

set autoindent

set tabstop=4
set shiftwidth=4

set number
set relativenumber

if has('linebreak')
  " wrap long lines at a character in 'breakat' rather than at the last character that fits on the screen.
  set linebreak
endif

set ruler
set showcmd

if has('extra_search')
  " highlight search
  set hlsearch
endif

set ignorecase
set smartcase

if has('autochdir')
  set autochdir
endif

set autoread

set list
set listchars=tab:▸\ 

if has('wildmenu')
  set wildmenu
endif
set wildmode=longest:full,list:full,full

call plug#begin()

Plug 'ntpeters/vim-better-whitespace'
Plug 'preservim/nerdtree'
Plug 'rust-lang/rust.vim'

call plug#end()
