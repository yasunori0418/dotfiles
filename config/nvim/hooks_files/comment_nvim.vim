" hook_add {{{
omap gc <Plug>(comment_toggle_linewise)
omap gb <Plug>(comment_toggle_blockwise)
nmap gc <Plug>(comment_toggle_linewise)
nmap gb <Plug>(comment_toggle_blockwise)
nmap <expr> gcc v:count == 0 ? '<Plug>(comment_toggle_linewise_current)' : '<Plug>(comment_toggle_linewise_count)'
nmap <expr> gbc v:count == 0 ? '<Plug>(comment_toggle_blockwise_current)' : '<Plug>(comment_toggle_blockwise_count)'
xmap gc <Plug>(comment_toggle_linewise_visual)
xmap gb <Plug>(comment_toggle_blockwise_visual)
" }}}
