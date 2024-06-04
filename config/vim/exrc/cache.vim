let s:cache_dir = expand('$XDG_CACHE_HOME/vim')

 " make backup file.
let s:backupdir = $'{s:cache_dir}/backup'
if !isdirectory(s:backupdir)
  call mkdir(s:backupdir, 'p')
endif
execute $'set backupdir={s:backupdir}'
set backup

" make swap file.
let s:swapdir = $'{s:cache_dir}/swap'
if !isdirectory(s:swapdir)
  call mkdir(s:swapdir, 'p')
endif
execute $'set directory={s:swapdir}'
set swapfile

" make undo file.
let s:undodir = $'{s:cache_dir}/undo'
if isdirectory(s:undodir)
  call mkdir(s:undodir, 'p')
endif
execute $'set undodir={s:undodir}'
set undofile

" }}}

