" Editor-Settings{{{
" Encoding{{{
" Use utf-8 to overall encoding.
set encoding=utf-8
scriptencoding utf-8

" Use utf-8 when file write.
set fileencoding=utf-8

" Use file encodings when loaded.
set fileencodings=utf-8,sjis,iso-2022-jp,euc-jp
" }}}

" Automatic line feed code recognition.
set fileformats=unix,dos

let s:cache_dir = expand('~/.cache/vim')

" make backup file.
let s:backup_dir = s:cache_dir . '/backup'
if isdirectory(s:backup_dir)
  call mkdir(s:backup_dir, 'p')
  execute 'set backupdir=' . s:backup_dir
  set backup
endif

" make swap file.
let s:swap_dir = s:cache_dir . '/swap'
if isdirectory(s:swap_dir)
  call mkdir(s:swap_dir, 'p')
  execute 'set directory=' . s:swap_dir
  set swapfile
endif

" make undo file.
let s:undo_dir = s:cache_dir . '/undo'
if isdirectory(s:undo_dir)
  call mkdir(s:swap_dir, 'p')
  execute 'set undodir=' . s:swap_dir
  set undofile
endif

" East asia ambigunous charactor width problem.
set ambiwidth=single

" Automatically load the file being edited
set autoread

" Move the cursor one character ahead of the end of the line
set virtualedit=block

" Use the clipboard on linux systems.
set clipboard+=unnamedplus

" diff vertical view
set diffopt+=vertical,algorithm:histogram,indent-heuristic

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
set list

"Tab/End line Space/End line/No brake space.
set listchars=tab:»-,space:･,trail:･,nbsp:%,eol:↲,extends:»,precedes:«
" }}}

" Keybind settings.
" Window control keybind {{{
" overwrites window command of 'CTRL-W'.
" Use prefix <Plug>(window).
nnoremap <Plug>(window) <Nop>
nmap <Space>w <Plug>(window)

" Commands of move between window.
nnoremap <Plug>(window)h <C-W>h
nnoremap <Plug>(window)j <C-W>j
nnoremap <Plug>(window)k <C-W>k
nnoremap <Plug>(window)l <C-W>l

" Commands of move window.
nnoremap <Plug>(window)H <C-W>H
nnoremap <Plug>(window)J <C-W>J
nnoremap <Plug>(window)K <C-W>K
nnoremap <Plug>(window)L <C-W>L

" Tab page controls.
nnoremap [t gT
nnoremap ]t gt
nnoremap [T <Cmd>tabfirst<CR>
nnoremap ]T <Cmd>tablast<CR>
nnoremap <Plug>(window)tn <Cmd>tabnew<CR>
nnoremap <Plug>(window)tT <C-W>T

" Commands of close window.
nnoremap <Plug>(window)q <C-W>q
nnoremap <Plug>(window)Q <Cmd>quit!<CR>

" easy save. save file only when changed.
nnoremap <Plug>(windows)w <Cmd>update<CR>

" Commands of window split.
nnoremap <Plug>(window)s <C-W>s
nnoremap <Plug>(window)v <C-W>v
nnoremap <Plug>(window)n <C-W>n

" Window size controls.
nnoremap <Plug>(window)<Bar> <C-W><Bar>
nnoremap <Plug>(window)_ <C-W>_
nnoremap <Plug>(window)= <C-W>=
" }}}

" Normal Mode:{{{
" Do not save the things erased by x and c in the register.
nnoremap x "_x
nnoremap c "_c

" Opens the file name under the cursor.
nnoremap gf gF

" Disable highlights from search results.
nnoremap <C-l> <Cmd>nohlsearch<Bar>diffupdate<CR><C-l>

" }}}

" Insert Mode:{{{

" Exit insert mode.
inoremap jj <ESC>
inoremap <C-l> <Del>

" }}}

" Visual Mode:{{{

" Do not save the things erased by x and c in the register.
xnoremap x "_x
xnoremap c "_c

" }}}

filetype plugin indent on
syntax on
