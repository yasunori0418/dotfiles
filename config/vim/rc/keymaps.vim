" Disable keymaps. {{{
" `s` and `S` same is `cl`, `cc` and `C` "
nnoremap s <Nop>
xnoremap s <Nop>
nnoremap S <Nop>
xnoremap S <Nop>

" unuse marker
nnoremap m <Nop>
xnoremap m <Nop>
nnoremap ' <Nop>
xnoremap ' <Nop>
nnoremap ` <Nop>
xnoremap ` <Nop>

" disable move left after space
nnoremap <Space> <Nop>
xnoremap <Space> <Nop>

" disable arrow keys for move
noremap <Left> <Nop>
noremap! <Left> <Nop>
noremap <Down> <Nop>
noremap! <Down> <Nop>
noremap <Up> <Nop>
noremap! <Up> <Nop>
noremap <Right> <Nop>
noremap! <Right> <Nop>
" }}}

" Window control keybind {{{
" overwrites window command of 'CTRL-W'.
" Use prefix <Plug>(window).
nmap <Space>w <Plug>(Window)

" Commands of move between window.
nnoremap <silent> <Plug>(Window)h <C-W>h
nnoremap <silent> <Plug>(Window)j <C-W>j
nnoremap <silent> <Plug>(Window)k <C-W>k
nnoremap <silent> <Plug>(Window)l <C-W>l

" Commands of move window.
nnoremap <silent> <Plug>(Window)H <C-W>H
nnoremap <silent> <Plug>(Window)J <C-W>J
nnoremap <silent> <Plug>(Window)K <C-W>K
nnoremap <silent> <Plug>(Window)L <C-W>L

" Tab page controls.
nnoremap <silent> <Plug>(Window)tn <Cmd>tabnew<CR>
nnoremap <silent> <Plug>(Window)tT <C-W>T

" Commands of close window.
nnoremap <silent> <Plug>(Window)q <C-W>q

" easy save. save file only when changed.
nnoremap <silent> <Plug>(Window)w <Cmd>update<CR>

" Commands of Window split.
nnoremap <silent> <Plug>(Window)s <C-W>s
nnoremap <silent> <Plug>(Window)v <C-W>v
nnoremap <silent> <Plug>(Window)n <C-W>n

" Window size controls.
nnoremap <silent> <Plug>(Window)<Bar> <C-W><Bar>
nnoremap <silent> <Plug>(Window)_ <C-W>_
nnoremap <silent> <Plug>(Window)= <C-W>=
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

" Tab {{{
nnoremap <silent> [t gT
nnoremap <silent> ]t gt
nnoremap <silent> [T <Cmd>tabfirst<CR>
nnoremap <silent> ]T <Cmd>tablast<CR>
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

" vim:foldmethod=marker
