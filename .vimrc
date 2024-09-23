" Personal vim
" **Must be first uncommented line**
set nocompatible

" Determine the system
let s:OS = 'linux'
let os = substitute(system('uname'), '\n', '', '')
if os == 'Darwin' || os == 'Mac'
    let s:OS = 'osx'
endif
let s:plugins=isdirectory(expand('~/.vim/bundle/vundle', 1))

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
" Remove trailing whitespace
" http://vim.wikia.com/wiki/Remove_unwanted_spaces
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
" Auto highlight toggle
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
" Check if a colorscheme exists
" http://stackoverflow.com/a/5703164
function! HasColorScheme(scheme)
    let basepath = '~/.vim/bundle/'
    for plug in g:color_schemes
        let path = basepath . '/' . plug . '/colors/' . a:scheme . '.vim'
        if filereadable(expand(path))
            return 1
        endif
    endfor
    return 0
endfunction

" Global Settings
" The comma leader
let mapleader = ','
let maplocalleader = '\'
" Large history
set history=9999
" Show line numbers on the left of the screen
set number
" Show the column/row
set ruler
" Highlight current line and column
set cursorline
set cursorcolumn
" Highlight only the lines that go past 80 characters
highlight ColorColumn ctermbg=green guibg=green
call matchadd('ColorColumn', '\%82v', 100)
" Syntax highlighting
syntax on
" Show the matching when doing a search
set showmatch
" Allows the backspace to delete indenting, end of lines, and over the start
" of insert
set backspace=indent,eol,start
" Ignore case when doing a search as well as highlight it as it is typed
set ignorecase smartcase
set hlsearch
set incsearch
" Don't show the startup message
set shortmess=I
" Show the current command at the bottom
set showcmd
" Disable beeping and flashing.
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=
" Use smarter defaults
set smartindent
set smarttab
" Use autoindenting
set autoindent
" Tabstop at 4 spacing
set tabstop=4
set softtabstop=4
set shiftwidth=4
" Spaces to indent code
set expandtab
" Show two lines for the status line
set laststatus=2
" Always show the last line
set display+=lastline
" UTF-8
set encoding=utf-8
" Enhanced mode for command-line completion
set wildmenu
" Automatically re-read the file if it has changed
set autoread

" Buffer Settings
set hidden
" Better completion
set completeopt+=longest,menuone,preview
" Turn on persistent undo
" github.com/mikewadsten/dotfiles/
if has('persistent_undo')
    set undodir=~/.vim/undo//
    set undofile
    set undolevels=1000
    set undoreload=10000
endif
" Use backups
" http://stackoverflow.com/a/15317146
set backup
set writebackup
set backupdir=~/.vim/backup//
" Use a specified swap folder
" http://stackoverflow.com/a/15317146
set directory=~/.vim/swap//

" Fold Settings
" Off on start
set nofoldenable
" Indent seems to work the best
set foldmethod=indent
set foldlevel=20

" Global Bindings
" Split the window using some nice shortcuts
nmap <leader>s<bar> :vsplit<cr>
nmap <leader>s- :split<cr>
nmap <leader>s? :map <leader>s<cr>
" Unhighlight the last search pattern on Enter
nn <silent> <cr> :nohlsearch<cr><cr>
" Control enhancements in insert mode
imap <C-F> <right>
imap <C-B> <left>
imap <M-BS> <esc>vBc
imap <C-P> <up>
imap <C-N> <down>
" Non quitting analog of ZZ
nmap zz :w<cr>
" When pushing j/k on a line that is wrapped, it navigates to the same line,
" just to the expected location rather than to the next line
nnoremap j gj
nnoremap k gk
" Use actually useful arrow keys
map <right> :bn<cr>
map <left> :bp<cr>
map <up> <nop>
map <down> <nop>
" Map Ctrl+V to paste in Insert mode
imap <C-V> <C-R>*
" Map Ctrl+C to copy in Visual mode
vmap <C-C> "+y
" Add paste shortcut
nmap <leader>P "+p
" Let's make the fonts look nice
if s:OS == 'osx'
    set guifont=Agave\ Nerd\ Font\ Mono
elseif s:OS == 'linux'
    set guifont=Hack\ Regular\ for\ Powerline\ 12
endif
" Ignore some defaults
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

" Custom Options
" Set on textwidth when in markdown files
autocmd FileType markdown set textwidth=80

if !s:plugins
    " Bootstrap Vundle on new systems
    " Borrowed from @justinmk's vimrc
    fun! InstallVundle()
        silent call mkdir(expand('~/.vim/bundle', 1), 'p')
        silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/vundle
    endfun
    " Instead of install packages, install Vundle
    nmap <leader>vi :call InstallVundle()<cr>
    else
    " Required by Vundle
    filetype off
    " Vundle is the new god among plugins
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()
  
    " Vundle Bundles + Settings
    Plugin 'VundleVim/Vundle.vim'
    " Git/GitHub plugins
    Plugin 'airblade/vim-gitgutter'
    " > A Vim plugin which shows git diff markers in the sign column
    " > and stages/previews/undoes hunks and partial hunks.
    " File overview
    Plugin 'Shougo/unite.vim'
    " > Run unite to display files and buffers as sources to pick from.
    Plugin 'Shougo/vimfiler.vim'
    " > A powerful file explorer implemented in Vim script
    " Navigation
    Plugin 'ctrlpvim/ctrlp.vim'
    " > Full path fuzzy file, buffer, mru, tag, ... finder for Vim.
    " Appearance
    Plugin 'vim-airline/vim-airline'
    " > Nice statusline at the bottom of each vim window.
    Plugin 'vim-airline/vim-airline-themes'
    " > Use :AirlineTheme <theme> to set the theme
    " Buffers
    Plugin 'jeetsukumaran/vim-buffergator'
    " > Vim plugin to list, select and switch between buffers.
    Plugin 'mtth/scratch.vim'
    " > Unobtrusive scratch window.
    " Syntax
    Plugin 'vim-syntastic/syntastic'
    " > Syntax checking hacks for vim.
    Plugin 'tpope/vim-markdown'
    " > Vim Markdown runtime files.
    " Utilities
    Plugin 'fenandosr/taskpaper.vim'
    Plugin 'direnv/direnv.vim'
    " Load devicons
    Plugin 'ryanoasis/vim-devicons'
    Plugin 'thedenisnikulin/vim-cyberpunk'
    let g:color_schemes = ['cyberpunk']
    " Must be loaded after all color scheme plugins
    if HasColorScheme('cyberpunk') && s:plugins
        colorscheme cyberpunk
    endif
    nmap <leader>t? :map <leader>t<cr>
    nmap <leader>tB :VimFiler<cr>
    nmap <leader>tb :VimFilerExplorer<cr>
    nmap <leader>tW :cal StripTrailingWhitespace()<cr>
    nmap <leader>tw :cal ToggleWhitespace()<cr>
  
    " Vundle mapping
    nmap <leader>vl :BundleList<cr>
    nmap <leader>vi :BundleInstall<cr>
    nmap <leader>vI :BundleInstall!<cr>
    nmap <leader>vc :BundleClean<cr>
    nmap <leader>vC :BundleClean!<cr>
    nmap <leader>v? :map <leader>v <cr>
  
    " VimFiler options
    let g:vimfiler_as_default_explorer = 1
    let g:vimfiler_ignore_pattern = [
            \ '^\.git$',
            \ '^\.cache$',
            \ '^__pycache__$',
            \ '^\.DS_Store$',
            \ '\.aux$',
            \ '\.sw[po]$',
            \ '\.class$',
            \ '\.py[co]$',
            \ '\.py[co]$',
        \ ]
  
    " Syntastic Settings
    let g:syntastic_always_populate_loc_list=1
    let g:syntastic_error_symbol = '✗'
    let g:syntastic_warning_symbol = '⚠'
    let g:syntastic_auto_loc_list = 2
    let g:syntastic_enable_signs = 1
  
    " CtrlP Settings
    let g:ctrlp_user_command = {
                \ 'types': {
                \ 1: ['.git', 'cd %s && git ls-files --exclude-standard --others --cached'],
                \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': 'find %s -type f'
                \ }
    " Use nearest .git dir
    let g:ctrlp_working_path_mode = 'ra'
    nmap <leader>p :CtrlP<cr>
  
    " Buffer controls to go with Buffergator
    nmap <leader>b? :map <leader>b<cr>
    nmap <leader>bb :CtrlPBuffer<cr>
    nmap <leader>bl :BuffergatorOpen<cr>
    nmap <leader>bm :CtrlPMixed<cr>
    nmap <leader>bq :bp <BAR> bd #<cr>
    nmap <leader>bs :CtrlPMRU<cr>
  
    " Buffergator Options
    let g:buffergator_suppress_keymaps = 1
    let g:buffergator_viewport_split_policy = "R"
    let g:buffergator_autoexpand_on_split = 0
    nmap <leader>T :enew<cr>
    nmap <leader>jj :BuffergatorMruCyclePrev<cr>
    nmap <leader>kk :BuffergatorMruCycleNext<cr>
  
  
    " Airline options
    let g:airline#extensions#branch#enabled = 1
    let g:airline#extensions#syntastic#enabled = 1
    let g:airline_theme = 'cyberpunk'
    let g:airline_powerline_fonts = 1
    " existance
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    " unicode symbols
    let g:airline_left_sep = '»'
    let g:airline_left_sep = '▶'
    let g:airline_right_sep = '«'
    let g:airline_right_sep = '◀'
    let g:airline_symbols.linenr = '␊'
    let g:airline_symbols.linenr = '␤'
    let g:airline_symbols.linenr = '¶'
    let g:airline_symbols.branch = '⎇'
    let g:airline_symbols.paste = 'ρ'
    let g:airline_symbols.paste = 'Þ'
    let g:airline_symbols.paste = '∥'
    let g:airline_symbols.whitespace = 'Ξ'
    " airline symbols
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.linenr = ''
    "let g:webdevicons_enable_airline_statusline_fileformat_symbols = 0
  
    " End the conditional for plugins
endif
" Load plugins and indent for the filtype
" **Must be last for Vundle**
filetype plugin indent on

" Misc/Non Plugin Settings
" Paste toggle to something easy
set pastetoggle=<leader>tP
" Bind :sort to something easy, don't press enter, allow for options (eg -u,
" n, sorting in reverse [sort!])
vnoremap <leader>s :sort

" Let's make it pretty
set background=dark
set t_Co=256
set t_AB=[48;5;%dm
set t_AF=[38;5;%dm
