" hook_add {{{
nnoremap <previm> <Nop>
nmap <Space>p <previm>
nnoremap <previm>o <Cmd>PrevimOpen<CR>
nnoremap <previm>r <Cmd>call previm#refresh()<CR>
" }}}

" hook_source {{{
let g:previm_enable_realtime = 1
let g:previm_disable_default_css = 1
let g:previm_custom_css_path = expand('~/dotfiles/tmp/previm_markdown.css')
let g:previm_plantuml_imageprefix = 'http://localhost:58080/png/'
" }}}
