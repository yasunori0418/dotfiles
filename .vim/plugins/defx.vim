autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
    "defx keymap

    " If it is a directory, open by tree-type.
    " Other than that, it opens.
    nnoremap <silent><buffer><expr> <CR>
    \ defx#is_directory() ?
        \ defx#do_action('open_or_close_tree') :
        \ defx#do_action('drop')

    " If it is a directory, open it.
    " Other than that, it opens.
    nnoremap <silent><buffer><expr> o
    \ defx#is_directory() ?
    \ defx#do_action('multi', ['open', 'change_vim_cwd']) :
        \ defx#do_action('drop')

    " Open to vertical split window with v-key.
    nnoremap <silent><buffer><expr> v
    \ defx#do_action('drop', 'vsplit')

    " Open to horizontal split window with s-key.
    nnoremap <silent><buffer><expr> s
    \ defx#do_action('drop', 'split')

    " Open to tab window with t-key.
    nnoremap <silent><buffer><expr> t
    \ defx#do_action('open', 'tabnew')

    " Preview in floating window with p-key.
    nnoremap <silent><buffer><expr> p
    \ defx#do_action('preview')

    " Toggle the cursor candidate select.
    nnoremap <silent><buffer><expr> <Space>
    \ defx#do_action('toggle_select')
    nnoremap <silent><buffer><expr> A
    \ defx#do_action('toggle_select_all')

    " Wrap when moving to the beginning and end of a line
    nnoremap <silent><buffer><expr> j
    \ line('.') == line('$') ?
        \ 'gg' : 'j'
    nnoremap <silent><buffer><expr> k
    \ line('.') == 1 ?
        \ 'G' : 'k'

    " Close defx buffer.
    nnoremap <silent><buffer><expr> q
    \ defx#do_action('quit')
    nnoremap <silent><buffer><expr> <ESC>
    \ defx#do_action('quit')

    " Create new file or directory.
    " If the input ends with /, it means new directory.
    nnoremap <silent><buffer><expr> n
    \ defx#do_action('new_multiple_files')

    " Move to the upper path
    nnoremap <silent><buffer><expr> ..
    \ defx#do_action('cd', ['..'])

    " Move to the HOME directory
    nnoremap <silent><buffer><expr> ~
    \ defx#do_action('cd')

    " Rename the file/directory 
    nnoremap <silent><buffer><expr> r
    \ defx#do_action('rename')

    " Copy paste and move files.
    nnoremap <silent><buffer><expr> C
    \ defx#do_action('copy')
    nnoremap <silent><buffer><expr> M
    \ defx#do_action('move')
    nnoremap <silent><buffer><expr> P
    \ defx#do_action('paste')

    " Yank path
    nnoremap <silent><buffer><expr> yy
    \ defx#do_action('yank_path')

    " Delete the file/directory to trashbox.
    nnoremap <silent><buffer><expr> D
    \ defx#do_action('remove_trash')
endfunction

" defx_icons configure
let g:defx_icons_column_length = 2

call defx#custom#option('_', {
    \ 'winwidth': 40,
    \ 'split': 'vertical',
    \ 'floating_preview': v:true,
    \ 'preview_height': 30,
    \ 'preview_width': 90,
    \ 'direction': 'topleft',
    \ 'show_ignored_files': v:true,
    \ 'toggle': v:true,
    \ 'resume': v:true,
    \ 'columns': 'indent:icons:filename:mark',
    \ })
