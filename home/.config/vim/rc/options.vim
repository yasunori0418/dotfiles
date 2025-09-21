" Editor-Settings {{{
" Encoding {{{
" Use utf-8 to overall encoding.
set encoding=utf-8
scriptencoding utf-8

" Use utf-8 when file write.
set fileencoding=utf-8

" Use file encodings when loaded.
set fileencodings=utf-8,sjis,iso-2022-jp,euc-jp
" }}}

" Cache {{{
let s:cache_dir = '$XDG_CACHE_HOME/vim'->expand()

 " make backup file.
let s:backupdir = $'{s:cache_dir}/backup'
if !isdirectory(s:backupdir)
  s:backupdir->mkdir('p')
endif
execute $'set backupdir={s:backupdir}'
set backup

" make swap file.
let s:swapdir = $'{s:cache_dir}/swap'
if !isdirectory(s:swapdir)
  s:swapdir->mkdir('p')
endif
execute $'set directory={s:swapdir}'
set swapfile

" make undo file.
let s:undodir = $'{s:cache_dir}/undo'
if isdirectory(s:undodir)
  s:undodir->mkdir('p')
endif
execute $'set undodir={s:undodir}'
set undofile

" }}}

" Automatic line feed code recognition.
set fileformats=unix,dos

" East asia ambigunous charactor width problem.
set ambiwidth=single

" Automatically load the file being edited
set autoread

" Move the cursor one character ahead of the end of the line
set virtualedit=block

" Use the clipboard on linux systems.
set clipboard=unnamedplus,unnamed

" diff vertical view
set diffopt+=vertical,algorithm:histogram,indent-heuristic

" no beep
set belloff=all

" }}}

" Display {{{
" Display rows number.
set number

" Display relative rows number.
set norelativenumber

" Display current row cursorline.
set cursorline

set termguicolors

" }}}

" Folding {{{
set foldmethod=marker
set foldlevel=0
set foldcolumn=3
" }}}

" Search {{{
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

" Indent {{{
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
" }}}

" Statusline {{{
" Display statusline.
set laststatus=2

" Command line completion.
set wildmenu

" Command history.
set history=5000
" }}}

" Invisible characters {{{
" Invisible characters
set list

"Tab/End line Space/End line/No brake space.
set listchars=tab:»-,space:･,trail:･,nbsp:%,eol:↲,extends:»,precedes:«
" }}}

