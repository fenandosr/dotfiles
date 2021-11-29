" Personal vim
" **Must be first uncommented line**
set nocompatible

"
" Determine the system
"

let s:OS = 'linux'

let os = substitute(system('uname'), '\n', '', '')
if os == 'Darwin' || os == 'Mac'
    let s:OS = 'osx'
endif

let s:plugins=isdirectory(expand('~/.vim/bundle/vundle', 1))

"
" Setup folder structure
"

if !isdirectory(expand('~/.vim/undo/', 1))
    silent call mkdir(expand('~/.vim/undo', 1), 'p')
endif

if !isdirectory(expand('~/.vim/backup/', 1))
    silent call mkdir(expand('~/.vim/backup', 1), 'p')
endif

if !isdirectory(expand('~/.vim/swap/', 1))
    silent call mkdir(expand('~/.vim/swap', 1), 'p')
endif

"
" Custom Functions
"

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

" Function to hide all the text except for the text selected in visual mode.
" This is great for highlighting parts of the code. Just call the function
" again to deselect everything.
function! ToggleSelected(visual) range
    highlight HideSelected ctermfg=black ctermbg=black
                         \ guifg=black guibg=black gui=none term=none cterm=none

    if exists('g:toggle_selected_hide')
        call matchdelete(g:toggle_selected_hide)

        unlet g:toggle_selected_hide
        redraw

        if !a:visual
            return
        endif
    endif

    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]

    let pattern = '\%^\|\%<'.lnum1.'l\|\%<'.col1.'v\|\%>'.lnum2.'l\|\%>'.col2.'v'
    let g:toggle_selected_hide = matchadd('HideSelected', pattern, 1000)

    redraw
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

"
" Global Settings
"

" The default 20 isn't nearly enough
set history=9999

" Show the numbers on the left of the screen
set number

" Show the column/row
set ruler

" Highlight current line and column
set cursorline
set cursorcolumn

" Highlight only the lines that go past 80 characters
highlight ColorColumn ctermbg=green guibg=green
call matchadd('ColorColumn', '\%82v', 100)

" Pretty colors are fun, yayyy
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

" The tabstop look best at 4 spacing
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Spaces to indent code
set expandtab

" Buffer Settings
set hidden

" Better completion
set completeopt+=longest,menuone,preview

" Turn on persistent undo
" Thanks, Mr Wadsten: github.com/mikewadsten/dotfiles/
if has('persistent_undo')
    set undodir=~/.vim/undo//
    set undofile
    set undolevels=1000
    set undoreload=10000
endif

" Use backups
" Source:
"   http://stackoverflow.com/a/15317146
set backup
set writebackup
set backupdir=~/.vim/backup//

" Use a specified swap folder
" Source:
"   http://stackoverflow.com/a/15317146
set directory=~/.vim/swap//

" The comma makes a great leader of men, heh heh
let mapleader = ','
let maplocalleader = '\'

" Show two lines for the status line
set laststatus=2

" Always show the last line
set display+=lastline

" UTF-8 THIS SHITTTTTT
set encoding=utf-8

" Enhanced mode for command-line completion
set wildmenu

" Automatically re-read the file if it has changed
set autoread

" Fold Settings

" Off on start
set nofoldenable

" Indent seems to work the best
set foldmethod=indent
set foldlevel=20

"
" Global Bindings
"

" Disable ex mode, ick, remap it to Q instead.
"
" Tip:
"   Use command-line-window with q:
"   Use search history with q/
"
" More info:
" http://blog.sanctum.geek.nz/vim-command-window/
nmap Q q

" Show only selected in Visual Mode
nmap <silent> <leader>th :cal ToggleSelected(0)<cr>
vmap <silent> <leader>th :cal ToggleSelected(1)<cr>

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

" GVim Settings
if has('gui_running')
    " Who uses a GUI in GVim anyways? Let's be serious.
    set guioptions=egirLt

    " Ensure that clipboard isn't clobbered when yanking
    set guioptions-=a

endif

" Let's make the fonts look nice
if s:OS == 'osx'
    set guifont=Droid\ Sans\ Mono\ for\ Powerline:h11
elseif s:OS == 'linux'
    set guifont=Hack\ Regular\ for\ Powerline\ 12
endif

" Ignore some defaults
set wildignore=*.o,*.obj,*~,*.pyc
set wildignore+=.env
set wildignore+=.env[0-9]+
set wildignore+=.git,.gitkeep
set wildignore+=.tmp
set wildignore+=.coverage
set wildignore+=*DS_Store*
set wildignore+=.sass-cache/
set wildignore+=__pycache__/
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=.tox/**
set wildignore+=.idea/**
set wildignore+=*.egg,*.egg-info
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,*/Library/**,*/.rbenv/**
set wildignore+=*/.nx/**,*.app

" Fold Keybindings
"nnoremap <space> za

"
" Custom Settings
"

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

"
" Vundle Bundles + Settings
"

Plugin 'VundleVim/Vundle.vim'

" Git/GitHub plugins
Plugin 'airblade/vim-gitgutter'
" > A Vim plugin which shows git diff markers in the sign column
" > and stages/previews/undoes hunks and partial hunks.
Plugin 'tpope/vim-fugitive'
" > The crown jewel of Fugitive is :Git (or just :G),
" >  which calls any arbitrary Git command.
Plugin 'tpope/vim-git'
" > :DiffGitCached, is provided to show a diff of the current commit
" > in the preview window.

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
Plugin 'bitc/vim-bad-whitespace'
" > Highlights whitespace at the end of lines

" Buffers
Plugin 'jeetsukumaran/vim-buffergator'
" > Vim plugin to list, select and switch between buffers.
Plugin 'mtth/scratch.vim'
" > Unobtrusive scratch window.

" Syntax
Plugin 'vim-syntastic/syntastic'
" > Syntax checking hacks for vim.
Plugin 'pangloss/vim-javascript'
" > JavaScript bundle for vim, this bundle provides
" > syntax highlighting and improved indentation.
Plugin 'tpope/vim-markdown'
" > Vim Markdown runtime files.

" Utilities
Plugin 'easymotion/vim-easymotion'
" > Provides a much simpler way to use some motions in vim.
Plugin 'mbbill/undotree'
" > The undo history visualizer.
Plugin 'mg979/vim-visual-multi'
" > Multiple cursors.
Plugin 'preservim/vimux'
" > Easily interact with tmux from vim.
Plugin 'tpope/vim-speeddating'
" > Use CTRL-A/CTRL-X to increment dates, times, and more.
Plugin 'tpope/vim-repeat'
" > Enable repeating supported plugin maps with '.'.
Plugin 'shougo/vimshell'
" > Powerful shell implemented by vim.
Plugin 'tpope/vim-commentary'
" > Comment stuff out.
Plugin 'fenandosr/taskpaper.vim'
Plugin 'direnv/direnv.vim'

" R Lang
Plugin 'jalvesaq/nvim-r'

" Autocompletion
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-surround'
" > Delete/change/add parentheses/quotes/XML-tags/much more with ease.
Plugin 'ycm-core/YouCompleteMe'

" Snippets
Plugin 'SirVer/ultisnips'

" Themes
Plugin 'freeo/vim-kalisi'

" Python
Plugin 'vimjas/vim-python-pep8-indent'
Plugin 'nvie/vim-flake8'

" Load devicons
Plugin 'ryanoasis/vim-devicons'

let g:color_schemes = ['vim-kalisi']

" Must be loaded after all color scheme plugins
if HasColorScheme('papercolor') && s:plugins
    colorscheme papercolor
endif

nmap <leader>t? :map <leader>t<cr>
nmap <leader>tB :VimFiler<cr>
nmap <leader>tb :VimFilerExplorer<cr>
nmap <leader>tW :cal StripTrailingWhitespace()<cr>
nmap <leader>tu :UndotreeToggle<cr>
nmap <leader>tw :cal ToggleWhitespace()<cr>

" Vundle mapping
nmap <leader>vl :BundleList<cr>
nmap <leader>vi :BundleInstall<cr>
nmap <leader>vI :BundleInstall!<cr>
nmap <leader>vc :BundleClean<cr>
nmap <leader>vC :BundleClean!<cr>
nmap <leader>v? :map <leader>v <cr>

" Fugitive mapping
nmap <leader>gW :Gwrite<cr>
nmap <leader>gR :Gread<cr>
nmap <leader>gb :Gblame<cr>
nmap <leader>gc :Gcommit<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gg :Ggrep
nmap <leader>gl :Glog<cr>
nmap <leader>gp :Git pull<cr>
nmap <leader>gP :Git push<cr>
nmap <leader>gs :Gstatus<cr>
nmap <leader>gw :Gbrowse<cr>
nmap <leader>g? :map <leader>g<cr>

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

autocmd BufEnter * if (winnr('$') == 1 && &filetype ==# 'vimfiler') | q | endif

call vimfiler#custom#profile('default', 'context', {
            \ 'explorer' : 1,
            \ 'safe' : 0,
            \ })


" Automatically open VimFiler whenever opened with GUI, but not terminal
if has('gui_running')
    autocmd VimEnter * VimFilerExplorer
    "autocmd VimEnter * wincmd p
endif

" Syntastic Settings
let g:syntastic_always_populate_loc_list=1
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_auto_loc_list = 2
let g:syntastic_enable_signs = 1
let g:syntastic_java_checkers = ['checkstyle', 'javac']
let g:syntastic_java_javac_delete_output = 1
let g:syntastic_filetype_map = { 'rnoweb': 'tex'}

" UltiSnip options
let g:UltiSnipsExpandTrigger="<C-SPACE>"


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

" Airline options
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline_theme = 'papercolor'
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

" Whitespace settings

" Show trailing whitespace and tabs obnoxiously
set list listchars=tab:▸\ ,trail:.
set list

fun! ToggleWhitespace()
    ToggleBadWhitespace
    if &list
        set nolist
    else
        set list listchars=tab:▸\ ,trail:.
        set list
    endif
endfun

" Easymotion
map <space> <Plug>(easymotion-prefix)

let g:EasyMotion_smartcase = 1
map <space>h <Plug>(easymotion-lineforward)
map <space>j <Plug>(easymotion-j)
map <space>k <Plug>(easymotion-k)
map <space>l <Plug>(easymotion-linebackward)

let g:EasyMotion_startofline = 0

" Undotree settings
let g:undotree_SplitWidth = 30
let g:undotree_WindowLayout = 3

" Multiple Cursors Settings
let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_next_key = '<C-j>'
let g:multi_cursor_prev_key = '<C-k>'
let g:multi_cursor_skip_key = '<C-x>'
let g:multi_cursor_quit_key = '<Esc>'

" Worthless mapping
let g:vimrplugin_assign = 0
let g:vimrplugin_insert_mode_cmds = 0

"
" Buffergator Options
"

let g:buffergator_suppress_keymaps = 1
let g:buffergator_viewport_split_policy = "R"
let g:buffergator_autoexpand_on_split = 0

nmap <leader>T :enew<cr>
nmap <leader>jj :BuffergatorMruCyclePrev<cr>
nmap <leader>kk :BuffergatorMruCycleNext<cr>

" Use extra conf file
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

" Ignore certain filetypes
let g:ycm_filetype_blacklist = {
\ 'tagbar': 1,
\ 'qf': 1,
\ 'notes': 1,
\ 'markdown': 1,
\ 'unite': 1,
\ 'text': 1,
\ 'vimwiki': 1,
\ 'pandoc': 1,
\ 'infolog': 1,
\ 'mail': 1,
\ 'gitcommit': 1,
\}

" Close the preview when leaving insert mode
" https://vi.stackexchange.com/questions/4056/is-there-an-easy-way-to-close-a-scratch-buffer-preview-window
let g:ycm_autoclose_preview_window_after_insertion = 1

"
" Vimux Settings
"

if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif


if has('gui_running')
    let g:VimuxUseNearest = 1
    let g:VimuxRunnerType = 'window'
else
    let g:VimuxUseNearest = 0
    let g:VimuxRunnerType = 'pane'
endif

let g:VimuxPromptString = 'tmux > '

function! VimuxSetupRacket()
    call VimuxRunCommand('racket -il readline')
    call VimuxClearRunnerHistory()
endfunction

function! VimuxQuitRacket()
    call VimuxInterruptRunner()
    call VimuxCloseRunner()
endfunction

function! VimuxRunSelection() range
    let [lnum1, col1] = getpos(''<')[1:2]
    let [lnum2, col2] = getpos(''>')[1:2]

    let lines = getline(lnum1, lnum2)

    let lines[-1] = lines[-1][: col2 - 1]
    let lines[0] = lines[0][col1 - 1:]

    call VimuxRunCommand(join(lines, "\n"))
endfunction

function! VimuxRunLine()
    call VimuxRunCommand(getline('.'))
endfunction

function! VimuxRunParagraph()
    let [lnum1] = getpos("'{")[1:1]
    let [lnum2] = getpos("'}")[1:1]

    let lines = getline(lnum1, lnum2)
    let filtered = filter(lines, 'v:val !~ "^\s*;"')

    call VimuxRunCommand(join(filtered, ''))
endfunction

" Setup autocmd if Racket filetype
autocmd FileType racket call SetupVimuxRacket()

function! SetupVimuxRacket()
    set shiftwidth=2

    " Start interpretter
    nmap <silent> <localleader>ri :call VimuxSetupRacket()<cr>
    nmap <silent> <localleader>rq :call VimuxQuitRacket()<cr>
    nmap <silent> <localleader>rl :call VimuxRunLine()<cr>
    nmap <silent> <localleader>R :call VimuxRunParagraph()<cr> nmap <silent> <localleader>rp :call VimuxRunParagraph()<cr>
    vmap <silent> <localleader>R :call VimuxRunSelection()<cr>
endfunction

" End the conditional for plugins
endif

" Load plugins and indent for the filtype
" **Must be last for Vundle**
filetype plugin indent on

"
" Misc/Non Plugin Settings
"

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
