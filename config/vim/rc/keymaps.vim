" Keybind settings.
" Window control keybind {{{
" overwrites window command of 'CTRL-W'.
" Use prefix <Plug>(window).
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
nnoremap <Plug>(window)w <Cmd>update<CR>

" Commands of window split.
nnoremap <Plug>(window)s <C-W>s
nnoremap <Plug>(window)v <C-W>v
nnoremap <Plug>(window)n <C-W>n

" Window size controls.
nnoremap <Plug>(window)<Bar> <C-W><Bar>
nnoremap <Plug>(window)_ <C-W>_
nnoremap <Plug>(window)= <C-W>=
" }}}

" QuickFix {{{
nnoremap <silent> [q <Cmd>cprevious<CR>
nnoremap <silent> ]q <Cmd>cnext<CR>
nnoremap <silent> [Q <Cmd>cfirst<CR>
nnoremap <silent> ]Q <Cmd>clast<CR>
" }}}

" Buffer {{{
nnoremap <silent> [b <Cmd>bprevious<CR>
nnoremap <silent> ]b <Cmd>bnext<CR>
nnoremap <silent> [B <Cmd>bfirst<CR>
nnoremap <silent> ]B <Cmd>blast<CR>
" }}}

" Normal Mode: {{{
" Do not save the things erased by x and c in the register.
nnoremap x "_x
nnoremap c "_c

" Opens the file name under the cursor.
nnoremap gf gF

" Disable highlights from search results.
nnoremap <C-l> <Cmd>nohlsearch<Bar>diffupdate<CR><C-l>

" }}}

" Insert Mode: {{{

" Exit insert mode.
inoremap jj <ESC>
inoremap <C-l> <Del>

" }}}

" Visual Mode: {{{

" Do not save the things erased by x and c in the register.
xnoremap x "_x
xnoremap c "_c

" }}}
