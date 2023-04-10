" hook_add {{{
nnoremap gs <Cmd>GinStatus<CR>
nnoremap gl <Cmd>GinLog ++opener=vsplit --graph --all --abbrev-commit --oneline<CR>
nnoremap gpl <Cmd>Gin pull<CR>
nnoremap gps <Cmd>Gin push --verbose --progress<CR>
nnoremap gC <Cmd>Gin commit<CR>
nnoremap gB <Cmd>GinBranch<CR>
" }}}

" gin-log {{{
setlocal nonumber
setlocal norelativenumber
" }}}

" gin-status {{{
setlocal nonumber
setlocal norelativenumber
" }}}

" gin-branch {{{
setlocal nonumber
setlocal norelativenumber
" }}}
