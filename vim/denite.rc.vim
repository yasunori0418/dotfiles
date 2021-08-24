nnoremap [denite] <Nop>
nmap <Space>d [denite]
nnoremap [denite]b :Denite buffer file:new<CR>
nnoremap [denite]f :Denite file file:new<CR>
nnoremap [denite]a :Denite file buffer file:new<CR>
nnoremap [denite]r :Denite file/rec buffer file:new<CR>
nnoremap [denite]h :Denite help<CR>
nnoremap [denite]g :Denite grep<CR>

autocmd FileType denite set winblend=30
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
    " Open to current window with Ente-key
    nnoremap <silent><buffer><expr> <CR>
    \ denite#do_map('do_action')

    " Open to current window with o-key
    nnoremap <silent><buffer><expr> o
    \ denite#do_map('do_action', 'open')
    nnoremap <silent><buffer><expr> O
    \ denite#do_map('do_action', 'switch')

    " Open to horizontal split window with s-key
    nnoremap <silent><buffer><expr> s
    \ denite#do_map('do_action', 'split')
    nnoremap <silent><buffer><expr> S
    \ denite#do_map('do_action', 'splitswitch')

    " Open to vertical split window with v-key
    nnoremap <silent><buffer><expr> v
    \ denite#do_map('do_action', 'vsplit')
    nnoremap <silent><buffer><expr> V
    \ denite#do_map('do_action', 'vsplitswitch')

    " Open to tab window with t-key
    nnoremap <silent><buffer><expr> t
    \ denite#do_map('do_action', 'tabopen')
    nnoremap <silent><buffer><expr> T
    \ denite#do_map('do_action', 'tabswitch')

    " Remove from buffer list
    nnoremap <silent><buffer><expr> d
    \ denite#do_map('do_action', 'delete')

    " Move to the upper path and restart Denite buffer.
    nnoremap <silent><buffer><expr> ..
    \ denite#do_map('move_up_path')

    " Preview using bat.
    nnoremap <silent><buffer><expr> p
    \ denite#do_map('do_action', 'preview_bat')

    " Command to close Denite buffer, ESC and q
    nnoremap <silent><buffer><expr> <ESC>
    \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> q
    \ denite#do_map('quit')

    " Switch to file search mode with i-key 
    nnoremap <silent><buffer><expr> i
    \ denite#do_map('open_filter_buffer')

    " Select multiple files with <Space>
    nnoremap <silent><buffer><expr> <Space>
    \ denite#do_map('toggle_select').'j'
endfunction

" Change file/rec command.
call denite#custom#var('file/rec', 'command',
    \ ['rg', '--files', '--glob', '!.git', '--color', 'never'])
" Ripgrep command on grep source
call denite#custom#var('grep', {
    \ 'command': ['rg'],
    \ 'default_opts': ['-i', '--vimgrep', '--no-heading'],
    \ 'recursive_opts': [],
    \ 'pattern_opt': ['--regexp'],
    \ 'separator': ['--'],
    \ 'final_opts': [],
    \ })
call denite#custom#option('_', {
    \ 'split': 'floating',
    \ 'prompt': '❯'
    \ })
