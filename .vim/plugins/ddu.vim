call ddu#custom#patch_global({
    \ 'ui': 'ff',
    \ 'uiParams': {
    \     'ff': {
    \         'previewFloating': v:true,
    \         'split': 'floating',
    \         'prompt': '',
    \         'filterSplitDirection': 'floating',
    \         'displaySourceName': 'long',
    \         },
    \     },
    \ 'sourceOptions': {
    \     '_': {
    \         'ignoreCase': v:true,
    \         'matchers': [ 'matcher_substring' ],
    \         },
    \     'dein': {
    \         'defaultAction': 'cd'
    \         },
    \     'help': {
    \         'defaultAction': 'open',
    \         },
    \     },
    \ 'kindOptions': {
    \     'file': {
    \         'defaultAction': 'open',
    \         },
    \     'action': {
    \         'defaultAction': 'do',
    \         },
    \     'word': {
    \         'defaultAction': 'append',
    \         },
    \     },
    \ })

call ddu#custom#patch_local('current', {
    \ 'sources': [
    \     {'name': 'file'},
    \     {'name': 'buffer'},
    \     ],
    \ })

call ddu#custom#patch_local('dotfiles', {
    \ 'uiParams': {
    \     'ff': {
    \         'startFilter': v:true,
    \         }
    \     },
    \ 'sourceParams': {
    \     'file_rec': {'path': expand('~') .. '/dotfiles'},
    \     },
    \ 'sources': [{'name': 'file_rec'}],
    \ })

" call ddu#custom#patch_local('help', {
"     \ 'uiParams': {
"     \     'ff': {
"     \         'startFilter': v:true,
"     \         }
"     \     },
"     \ 'sources': [{'name': 'help'}],
"     \ })

call ddu#custom#patch_local('buffer', {
    \ 'sources': [{'name': 'buffer'}],
    \ })

call ddu#custom#patch_local('plugin-list', {
    \ 'uiParams': {
    \     'ff': {
    \         'startFilter': v:true,
    \         }
    \     },
    \ 'sources': [{'name': 'dein'}],
    \ })

call ddu#custom#patch_local('HOME', {
    \ 'uiParams': {
    \     'ff': {
    \         'startFilter': v:true,
    \         }
    \     },
    \ 'sourceParams': {
    \     'file': {'path': expand('~')},
    \     },
    \ 'sources': [{'name': 'file'}],
    \ })

call ddu#custom#patch_local('register', {
    \ 'sources': [{'name': 'register'}],
    \ })

autocmd FileType ddu-ff call s:ddu_ff_keybind()
function! s:ddu_ff_keybind() abort

    " Edit file.
    nnoremap <buffer><silent> <CR>
    \ <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>

    " Multiple selection.
    nnoremap <buffer><silent> <Space>
    \ <Cmd>call ddu#ui#ff#do_action('toggleSelectItem')<CR>

    " Open selection menu.
    nnoremap <buffer><silent> a
    \ <Cmd>call ddu#ui#ff#do_action('chooseAction')<CR>

    " Move directory.
    nnoremap <buffer><silent> c
    \ <Cmd>call ddu#ui#ff#do_action('itemAction', {'name': 'cd'})<CR>

    " Delete buffer list.
    nnoremap <buffer><silent> d
    \ <Cmd>call ddu#ui#ff#do_action('itemAction', {'name': 'delete'})<CR>

    " Open file with split window.
    nnoremap <buffer><silent> s
    \ <Cmd>call ddu#ui#ff#do_action('itemAction',
    \ {'name': 'open', 'params': {'command': 'split'}})<CR>
    nnoremap <buffer><silent> S
    \ <Cmd>call ddu#ui#ff#do_action('itemAction',
    \ {'name': 'open', 'params': {'command': 'splitswitch'}})<CR>
    nnoremap <buffer><silent> v
    \ <Cmd>call ddu#ui#ff#do_action('itemAction',
    \ {'name': 'open', 'params': {'command': 'vsplit'}})<CR>
    nnoremap <buffer><silent> V
    \ <Cmd>call ddu#ui#ff#do_action('itemAction',
    \ {'name': 'open', 'params': {'command': 'vsplitswitch'}})<CR>

    " Open file with another tab.
    nnoremap <buffer><silent> t
    \ <Cmd>call ddu#ui#ff#do_action('itemAction',
    \ {'name': 'open', 'command': 'tabopen'})<CR>
    nnoremap <buffer><silent> t
    \ <Cmd>call ddu#ui#ff#do_action('itemAction',
    \ {'name': 'open', 'command': 'tabswitch'})<CR>

    " Open filter Window.
    nnoremap <buffer><silent> i
    \ <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>

    " Open preview window.
    nnoremap <buffer><silent> p
    \ <Cmd>call ddu#ui#ff#do_action('preview')<CR>

    " Close ddu window.
    nnoremap <buffer><silent> q
    \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
    nnoremap <buffer><silent> <Esc>
    \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>

endfunction

autocmd FileType ddu-ff-filter call s:ddu_ff_filter_keybind()
function! s:ddu_ff_filter_keybind() abort

    inoremap <buffer><silent> <CR>
    \ <Esc><Cmd>close<CR>
    inoremap <buffer><silent> jj
    \ <Esc><Cmd>close<CR>

    nnoremap <buffer><silent> <CR>
    \ <Cmd>close<CR>
    nnoremap <buffer><silent> jj
    \ <Cmd>close<CR>

endfunction
