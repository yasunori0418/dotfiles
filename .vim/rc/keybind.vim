" Normal Mode:{{{
" Save file  when the push Space+w.
nnoremap <Space>w :w<CR>

" US Keyboard layout mapping.
" Exchange Colon and Semi-Colon.
nnoremap ; :
nnoremap : ;

" }}}


" Insert Mode:{{{

" Exit insert mode.
inoremap <silent> jj <ESC>

" }}}


" Visual Mode:{{{

" Exchange Colon and Semi-Colon.
xnoremap ; :
xnoremap : ;

" }}}
