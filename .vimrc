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

set icon

set iconstring=''

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


nnoremap ; :
nnoremap : ;
nnoremap q; q:
xnoremap ; :
xnoremap : ;
inoremap jj <Esc>
nnoremap <Space>w <Cmd>write<CR>

filetype plugin indent on
syntax on
