" hook_add {{{
let g:sandwich_no_default_key_mappings = 1

" add
nmap sa <Plug>(sandwich-add)
xmap sa <Plug>(sandwich-add)
omap sa <Plug>(sandwich-add)

" delete
nmap sd <Plug>(sandwich-delete)
xmap sd <Plug>(sandwich-delete)
nmap sdb <Plug>(sandwich-delete-auto)

" replace
nmap sr <Plug>(sandwich-replace)
xmap sr <Plug>(sandwich-replace)
nmap srb <Plug>(sandwich-replace-auto)
" }}}
