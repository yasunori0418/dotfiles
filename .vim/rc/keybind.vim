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

" Commands of buffer write.
nnoremap [Window]w <Cmd>write<CR>
nnoremap [Window]ww <Cmd>write<CR>
nnoremap [Window]wu <Cmd>write<CR>
nnoremap [Window]wa <Cmd>wall<CR>
nnoremap [Window]wq <Cmd>wq<CR>

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

" }}}


" Insert Mode:{{{

" Exit insert mode.
inoremap <silent> jj <ESC>

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

function! s:Clear_Register() abort
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
      call setreg(r, [])
    endfor
endfunction

command! Cleareg call s:Clear_Register()

" }}}
