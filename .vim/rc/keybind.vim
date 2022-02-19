" Normal Mode:{{{
" Save file when the push Space+w.
nnoremap <Space>w :w<CR>


" US Keyboard layout mapping.
" Exchange Colon and Semi-Colon.
" nnoremap ; :
nnoremap : ;


" Do not save the things erased by x and s in the register.
nnoremap x "_x
nnoremap s "_s


" }}}


" Insert Mode:{{{

" Exit insert mode.
inoremap <silent> jj <ESC>

" }}}


" Visual Mode:{{{

" Exchange Colon and Semi-Colon.
" xnoremap ; :
xnoremap : ;


" Do not save the things erased by x and s in the register.
xnoremap x "_x
xnoremap s "_s

" }}}
