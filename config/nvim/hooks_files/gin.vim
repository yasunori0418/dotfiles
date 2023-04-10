" hook_add {{{
nnoremap gs <Cmd>GinStatus<CR>
nnoremap gl <Cmd>GinLog ++opener=vsplit --graph --all --abbrev-commit --oneline<CR>
nnoremap gpl <Cmd>Gin pull<CR>
nnoremap gps <Cmd>Gin push --verbose --progress<CR>
nnoremap gm <Cmd>Gin commit<CR>
nnoremap gM <Cmd>Gin commit --amend<CR>
" }}}

" gin-log {{{
setlocal nonumber
setlocal norelativenumber
" }}}

" gin-status {{{
setlocal nonumber
setlocal norelativenumber
" }}}
