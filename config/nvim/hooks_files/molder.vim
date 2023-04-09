" molder {{{
nmap <buffer> ..    <Plug>(molder-up)
nmap <buffer> <C-l> <Plug>(molder-reload)
nmap <buffer> N     <Plug>(molder-operations-newdir)
nmap <buffer> D     <Plug>(molder-operations-delete)
nmap <buffer> R     <Plug>(molder-operations-rename)
nmap <buffer> S     <Plug>(molder-operations-shell)
nmap <buffer> !     <Plug>(molder-operations-command)
nmap <buffer> C <Cmd>call vimrc#molder_change_cwd()<CR>
" }}}
