
" Disable default plugins {{{
" Fast Startup Settings!!
" Disable TOhtml.
let g:loaded_2html_plugin       = v:true

" Disavle archive file open and browse.
let g:loaded_gzip               = v:true
let g:loaded_tar                = v:true
let g:loaded_tarPlugin          = v:true
let g:loaded_zip                = v:true
let g:loaded_zipPlugin          = v:true

" Disable vimball.
let g:loaded_vimball            = v:true
let g:loaded_vimballPlugin      = v:true

" Disable netrw plugins.
let g:loaded_netrw              = v:true
let g:loaded_netrwPlugin        = v:true
let g:loaded_netrwSettings      = v:true
let g:loaded_netrwFileHandlers  = v:true

" Disable `GetLatestVimScript`.
let g:loaded_getscript          = v:true
let g:loaded_getscriptPlugin    = v:true

" Disable other plugins
let g:loaded_man                = v:true
let g:loaded_matchparen         = v:true
let g:loaded_shada_plugin       = v:true
let g:loaded_spellfile_plugin   = v:true
let g:loaded_tutor_mode_plugin  = v:true
let g:did_install_default_menus = v:true
let g:did_install_syntax_menu   = v:true
let g:skip_loading_mswin        = v:true
let g:did_indent_on             = v:true
let g:did_load_ftplugin         = v:true
let g:loaded_rrhelper           = v:true

" }}}

" Editor-Settings {{{
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

" Disable backup.
set nobackup

" Don't make swap file.
set noswapfile

if has('persistent_undo')
  let s:undo_path = expand('~/.cache/nvim/undo')
  execute 'set undodir=' . s:undo_path
  set undofile
endif

" East asia ambigunous charactor width problem.
set ambiwidth=single

" Automatically load the file being edited
set autoread

" Use the clipboard on linux systems.
set clipboard+=unnamedplus

" open diff mode vertically
set diffopt+=vertical

" }}}

" Display{{{
" Display rows number.
set number

" Display relative rows number.
set relativenumber

" Display current row cursorline.
set cursorline

" True color terminal settings.
if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Transparency of pop-up menus such as completion
set pumblend=30
highlight PmenuSel blend=0
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

" }}}

" Invisible characters{{{
" Invisible characters
set list

"Tab/End line Space/End line/No brake space.
set listchars=tab:»-,space:･,trail:･,nbsp:%,eol:↲,extends:»,precedes:«
" }}}

" User settings auto command group. {{{

augroup user_filename_filetype
  autocmd!
  autocmd BufNewFile,BufRead *.blade.*    setlocal filetype=html
  autocmd BufNewFile,BufRead .textlintrc  setlocal filetype=json
augroup END

augroup user_filetype_indent
  autocmd!
  autocmd FileType html       setlocal tabstop=2 softtabstop=2 shiftwidth=2
  autocmd FileType css        setlocal tabstop=2 softtabstop=2 shiftwidth=2
  autocmd FileType python     setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType php        setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType xml        setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType markdown   setlocal tabstop=4 softtabstop=4 shiftwidth=4
augroup END

" }}}
