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

" Do not save the things erased by x and c in the register.
nnoremap x "_x
xnoremap x "_x
nnoremap c "_c
xnoremap c "_c
nnoremap C "_C
xnoremap C "_C

" Opens the file name under the cursor.
nnoremap <silent> gf gF

" Disable highlights from search results.
nnoremap <silent> <C-l> <Cmd>nohlsearch<Bar>diffupdate<CR><C-l>

" Exit insert mode and cmdline mode.
inoremap <silent> jj <ESC><C-l>
cnoremap <silent> jj <ESC><C-l>

inoremap <C-l> <Del>
inoremap <C-a> <C-g>U<Home>

" cmdline mode cursor move emacs like
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Left>
cnoremap <C-b> <Right>

" Operator
onoremap <silent> a' 2i'
xnoremap <silent> a' 2i'
onoremap <silent> a" 2i"
xnoremap <silent> a" 2i"
onoremap <silent> a` 2i`
xnoremap <silent> a` 2i`
onoremap <silent> a<Space> aW
xnoremap <silent> a<Space> aW
onoremap <silent> i<Space> iW
xnoremap <silent> i<Space> iW

" vim:foldmethod=marker
