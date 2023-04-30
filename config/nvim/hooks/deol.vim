" hook_add {{{
nmap <Space>s <Plug>(term)
nmap <Plug>(term)a <Cmd>execute 'Deol'
  \ '-no-auto-cd'
  \ '-no-start-insert'
  \ '-split=floating'
  \ '-winheight=' . float2nr(&lines / 1.5)
  \ '-winwidth=' . float2nr(&columns / 1.5)
  \ '-toggle'<CR>

nmap <Plug>(term)t <Cmd>tabnew<Bar>Deol -no-start-insert<CR>
nmap <Plug>(term)c <Cmd>execute 'Deol'
  \ '-cwd=' . fnamemodify(expand('%'), ':h')
  \ '-no-auto-cd'
  \ '-no-start-insert'
  \ '-split=floating'
  \ '-winheight=' . float2nr(&lines / 1.5)
  \ '-winwidth=' . float2nr(&columns / 1.5)
  \ '-toggle'<CR>
nmap <Plug>(term)h <Cmd>execute 'Deol'
  \ '-cwd=~'
  \ '-no-start-insert'
  \ '-split=floating'
  \ '-winheight=' . float2nr(&lines / 1.5)
  \ '-winwidth=' . float2nr(&columns / 1.5)
  \ '-toggle'<CR>

" Escape deol
tnoremap <Esc> <C-\><C-n>
" }}}

" hook_source {{{
" let g:deol#prompt_pattern = '^❯ \?'
" let g:deol#enable_ddc_completion = v:true
let g:deol#shell_history_path = expand('~/.zhistory')
let g:deol#enable_dir_changed = v:false
let g:deol#nvim_server = '~/.cache/nvim/server.pipe'
let g:deol#custom_map = #{edit: ''}
let g:deol#floating_border = 'double'
" }}}
