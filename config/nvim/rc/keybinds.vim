" keybinds
" Nop keys {{{
" Disable s for vim-sandwich
nnoremap s <Nop>
xnoremap s <Nop>
nnoremap S <Nop>
xnoremap S <Nop>

" Invalid because it does not move with t and T.
nnoremap t <Nop>
xnoremap t <Nop>
nnoremap T <Nop>
xnoremap T <Nop>

nnoremap m <Nop>

nnoremap <Space> <Nop>
xnoremap <Space> <Nop>

" kill arrow key move
noremap <Left>   <Nop>
noremap <Down>   <Nop>
noremap <Up>     <Nop>
noremap <Right>  <Nop>
noremap! <Left>   <Nop>
noremap! <Down>   <Nop>
noremap! <Up>     <Nop>
noremap! <Right>  <Nop>
" }}}

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

" Another window size controls.
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>
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

" Add Emacs-like keybindings to insert mode.
" When one line only...
inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$
inoremap <C-f> <C-G>U<Right>
inoremap <C-b> <C-G>U<Left>
" }}}

" Visual Mode:{{{

" Exchange Colon and Semi-Colon.
" xnoremap ; :
xnoremap : ;


" Do not save the things erased by x and c in the register.
xnoremap x "_x
xnoremap c "_c

" }}}

" Command {{{

command! Cleareg call vimrc#clear_register()

command! -bang DeinUpdate call vimrc#dein_update(<bang>0)

command! DeinDelete call vimrc#dein_check_uninstall()

command! -bar DeinRecache call dein#recache_runtimepath() | qall

" }}}
