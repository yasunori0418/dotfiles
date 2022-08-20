if &compatible
  set nocompatible
endif

" Editor-Settings{{{
" Encoding{{{
" Use utf-8 to overall encoding.
set encoding=utf-8

" Use utf-8 when file write.
set fileencoding=utf-8

" Use file encodings when loaded.
set fileencodings=utf-8,sjis,iso-2022-jp,euc-jp
" }}}

" Automatic line feed code recognition.
set fileformats=unix,dos

" Disable backup.
set nobackup

" Don't make swap file.
set noswapfile

" East asia ambigunous charactor width problem.
set ambiwidth=single

" Automatically load the file being edited
set autoread

" Move the cursor one character ahead of the end of the line
" set virtualedit=onemore

" Use the clipboard on linux systems.
set clipboard+=unnamedplus

" diff vertical view
set diffopt+=vertical

" no beep
set visualbell t_vb=

" }}}

" Display{{{
" Display rows number.
set number

" Display relative rows number.
set relativenumber

" Display current row cursorline.
set cursorline

" Show title bar string when X11.
set icon

" Set title string.
set iconstring='\ \|\ [%f]'

" True color terminal settings.
if exists('+termguicolors')
    let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

" Transparency of pop-up menus such as completion
"set pumblend=30
" }}}

" Folding{{{
set foldmethod=marker
set foldlevel=0
set foldcolumn=3
" }}}

" Search{{{
" Highlight search results
set hlsearch

" Incremental search.
" Search starts when you enter the first character of the search word.
set incsearch

" Search is not case sensitive
set ignorecase

" Searching in lowercase ignores uppercase and lowercase
set smartcase

" When the search progresses to the end of the file, search again from the beginning of the file.
set wrapscan
" }}}

" Indent{{{
" Smart indent.
set smartindent

" Insert tab with half-width space.
set expandtab

" The amount of blank space to insert with each command or smart indent.
set shiftwidth=2

" Tab width with 2 spaces.
set tabstop=2

" Insert a tab with 2 minutes of half-width space.
set softtabstop=2

let g:vim_indent_count = 0

augroup filetypeIndent
    autocmd!
    autocmd FileType html   setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType css    setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd FileType php    setlocal tabstop=4 softtabstop=4 shiftwidth=4
augroup END

" }}}

" Statusline{{{
" Display statusline.
set laststatus=2

" Command line completion.
set wildmenu

" Command history.
set history=5000
" }}} 

" Invisible characters{{{
" Invisible characters
"set list

"Tab/End line Space/End line/No brake space.
"set listchars=tab:»-,space:･,trail:･,nbsp:%,eol:↲,extends:»,precedes:«
" }}}

" Keybind settings.
" Window control keybind {{{
" overwrites window command of 'CTRL-W'.
" Use prefix [Window].
nnoremap <C-W> <Nop>
nnoremap [Window] <Nop>
nmap <Space>w [Window]

" Commands of move between window.
nnoremap [Window]h <C-W>h
nnoremap [Window]j <C-W>j
nnoremap [Window]k <C-W>k
nnoremap [Window]l <C-W>l

" Commands of move window.
nnoremap [Window]H <C-W>H
nnoremap [Window]J <C-W>J
nnoremap [Window]K <C-W>K
nnoremap [Window]L <C-W>L

" Tab page controls.
nnoremap [Window]th <C-W>gT
nnoremap [Window]tl <C-W>gt
nnoremap [Window]tt <C-W>g<Tab>
nnoremap [Window]tT <C-W>T
nnoremap [Window]tn <Cmd>tabnew<CR>
nnoremap [Window]tN <Cmd>-tabnew<CR>

" Commands of close window.
nnoremap [Window]q <C-W>q
nnoremap [Window]Q <Cmd>quit!<CR>
nnoremap [Window]o <C-W>o

" Commands of window split.
nnoremap [Window]s <C-W>s
nnoremap [Window]v <C-W>v
nnoremap [Window]n <C-W>n

" Window size controls.
nnoremap [Window]+ <C-W>+
nnoremap [Window]- <C-W>-
nnoremap [Window]= <C-W>=
nnoremap [Window]< <C-W><
nnoremap [Window]> <C-W>>
" }}}

" File save keybinds. {{{
nnoremap [Save] <Nop>
nmap <Space>s [Save]
nnoremap [Save]a <Cmd>wall<CR>
nnoremap [Save]q <Cmd>wq<CR>
nnoremap [Save]w <Cmd>write<CR>
nnoremap [Save]u <Cmd>update<CR>
" }}}

" Normal Mode:{{{
" US Keyboard layout mapping.
" Exchange Colon and Semi-Colon.
" nnoremap ; :
nnoremap : ;
nnoremap q; q:


" Do not save the things erased by x and c in the register.
nnoremap x "_x
nnoremap c "_c

" For vim-sandwich.
" nnoremap s <Nop>

" Opens the file name under the cursor.
nnoremap gf gF

" Disable highlights from search results.
nnoremap <Space>n <Cmd>nohlsearch<CR>

" }}}

" Insert Mode:{{{

" Exit insert mode.
inoremap jj <ESC>
inoremap <C-l> <Del>

" }}}

" Visual Mode:{{{

" Exchange Colon and Semi-Colon.
" xnoremap ; :
xnoremap : ;


" Do not save the things erased by x and c in the register.
xnoremap x "_x
xnoremap c "_c

" }}}

filetype plugin indent on
syntax on
