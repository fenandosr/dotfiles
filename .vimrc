" Personal vim
" **Must be first uncommented line**
set nocompatible

" Determine the system
let s:OS = 'linux'
let os = substitute(system('uname'), '\n', '', '')
if os == 'Darwin' || os == 'Mac'
    let s:OS = 'osx'
endif

" Setup folder structure
if !isdirectory(expand('~/.vim/undo/', 1))
    silent call mkdir(expand('~/.vim/undo', 1), 'p')
endif
if !isdirectory(expand('~/.vim/backup/', 1))
    silent call mkdir(expand('~/.vim/backup', 1), 'p')
endif
if !isdirectory(expand('~/.vim/swap/', 1))
    silent call mkdir(expand('~/.vim/swap', 1), 'p')
endif

" Custom Functions
function! StripTrailingWhitespace()
    if !&binary && &filetype != 'diff'
        normal mz
        normal Hmy
        %s/\s\+$//e
        normal 'yz<cr>
        normal `z
        retab
    endif
endfunction

nnoremap <space><space> :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=500
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction

" Global Settings
let mapleader = ','
let maplocalleader = '\'
set history=9999
set number
set ruler
set cursorline
set cursorcolumn
highlight ColorColumn ctermbg=green guibg=green
call matchadd('ColorColumn', '\%82v', 100)
syntax on
set showmatch
set backspace=indent,eol,start
set ignorecase smartcase
set hlsearch
set incsearch
set shortmess=I
set showcmd
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=
set smartindent
set smarttab
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set laststatus=2
set display+=lastline
set encoding=utf-8
set wildmenu
set autoread

" Buffer Settings
set hidden
set completeopt+=longest,menuone,preview
if has('persistent_undo')
    set undodir=~/.vim/undo//
    set undofile
    set undolevels=1000
    set undoreload=10000
endif
set backup
set writebackup
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//

" Fold Settings
set nofoldenable
set foldmethod=indent
set foldlevel=20

" Global Bindings
nmap <leader>s<bar> :vsplit<cr>
nmap <leader>s- :split<cr>
nmap <leader>s? :map <leader>s<cr>
nn <silent> <cr> :nohlsearch<cr><cr>
imap <C-F> <right>
imap <C-B> <left>
imap <M-BS> <esc>vBc
imap <C-P> <up>
imap <C-N> <down>
nmap zz :w<cr>
nnoremap j gj
nnoremap k gk
map <right> :bn<cr>
map <left> :bp<cr>
map <up> <nop>
map <down> <nop>
imap <C-V> <C-R>*
vmap <C-C> "+y
nmap <leader>P "+p

if s:OS == 'osx'
    set guifont=Agave\ Nerd\ Font\ Mono
elseif s:OS == 'linux'
    set guifont=Hack\ Regular\ for\ Powerline\ 12
endif

set wildignore+=.env,.envrc,.direnv
set wildignore+=.git,.gitkeep
set wildignore+=.tmp
set wildignore+=.coverage
set wildignore+=*DS_Store*
set wildignore+=*Thumbs.db*
set wildignore+=.sass-cache/
set wildignore=*.o,*.obj,*~,*.pyc
set wildignore+=__pycache__/
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=.tox/**
set wildignore+=*.egg,*.egg-info
set wildignore+=.idea/**
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,*/Library/**
set wildignore+=*/.nx/**,*.app

autocmd FileType markdown set textwidth=80

" ---------------------------------------------------------------------------
" Plugins (vim-plug)
" ---------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')

" Git
Plug 'airblade/vim-gitgutter'

" Fuzzy finder (usa el fzf ya instalado en el sistema)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Linting async (reemplaza Syntastic)
Plug 'dense-analysis/ale'

" Syntax / filetypes
Plug 'tpope/vim-markdown'

" Utilities
Plug 'direnv/direnv.vim'
Plug 'mtth/scratch.vim'

" Icons (carga al final)
Plug 'ryanoasis/vim-devicons'

" Colorscheme
Plug 'thedenisnikulin/vim-cyberpunk'

call plug#end()

colorscheme cyberpunk

" fzf (reemplaza CtrlP + Buffergator)
nmap <leader>p  :Files<cr>
nmap <leader>bb :Buffers<cr>
nmap <leader>bs :History<cr>
nmap <leader>bq :bp <BAR> bd #<cr>
nmap <leader>T  :enew<cr>

" ALE
let g:ale_sign_error            = '✗'
let g:ale_sign_warning          = '⚠'
let g:ale_lint_on_text_changed  = 'never'
let g:ale_lint_on_insert_leave  = 1

" Airline
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#ale#enabled   = 1
let g:airline_theme                     = 'cyberpunk'
let g:airline_powerline_fonts           = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep         = ''
let g:airline_left_alt_sep     = ''
let g:airline_right_sep        = ''
let g:airline_right_alt_sep    = ''
let g:airline_symbols.branch   = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr   = ''

" Misc
nmap <leader>tW :cal StripTrailingWhitespace()<cr>
nmap <leader>t? :map <leader>t<cr>

" ---------------------------------------------------------------------------
filetype plugin indent on

set pastetoggle=<leader>tP
vnoremap <leader>s :sort

set background=dark
set t_Co=256
