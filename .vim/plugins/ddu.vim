" Global source Options {{{
call ddu#custom#patch_global({
  \ 'uiParams': {
    \ 'ff': {
    \ 'previewFloating': v:true,
    \ 'split': 'floating',
    \ 'prompt': '',
    \ 'filterSplitDirection': 'floating',
    \ 'displaySourceName': 'long',
    \ },
  \ },
  \ 'sourceOptions': {
    \ '_': {
      \ 'ignoreCase': v:true,
      \ 'matchers': [ 'matcher_substring' ],
      \ },
    \ 'dein': {
      \ 'defaultAction': 'cd',
      \ },
    \ 'help': {
      \ 'defaultAction': 'open',
      \ },
    \ },
    \ 'kindOptions': {
      \ 'file': {
      \ 'defaultAction': 'open',
      \ },
    \ 'action': {
      \ 'defaultAction': 'do',
      \ },
    \ 'word': {
      \ 'defaultAction': 'append',
      \ },
    \ 'deol': {
      \ 'defaultAction': 'switch',
      \ },
    \ },
  \ })

" }}}

"ui fuzzy finder presets {{{
call ddu#custom#patch_local('current', {
  \ 'ui': 'ff',
  \ 'uiParams': {
    \ 'ff': {
    \ 'startFilter': v:true,
    \ },
  \ },
  \ 'sources': [
    \ {'name': 'file_rec'},
    \ {'name': 'buffer'},
    \ ],
  \ })

call ddu#custom#patch_local('dotfiles', {
  \ 'ui': 'ff',
  \ 'uiParams': {
    \ 'ff': {
    \ 'startFilter': v:true,
    \ },
  \ },
  \ 'sourceOptions': {
    \ 'file_rec': {'path': expand('~') . '/dotfiles'},
    \ },
  \ 'sources': [{'name': 'file_rec'}],
  \ })

call ddu#custom#patch_local('project-list', {
  \ 'ui': 'ff',
  \ 'uiParams': {
    \ 'ff': {
    \ 'startFilter': v:true,
    \ },
  \ },
  \ 'sourceOptions': {
    \ 'file': {'path': expand('~') . '/Project'},
    \ },
  \ 'sources': [{'name': 'file'}],
  \ })

call ddu#custom#patch_local('help', {
  \ 'ui': 'ff',
  \ 'uiParams': {
    \ 'ff': {
    \ 'startFilter': v:true,
    \ },
  \ },
  \ 'sources': [{'name': 'help'}],
  \ })

call ddu#custom#patch_local('buffer', {
  \ 'ui': 'ff',
  \ 'sources': [{'name': 'buffer'}],
  \ })

call ddu#custom#patch_local('plugin-list', {
  \ 'ui': 'ff',
  \ 'uiParams': {
    \ 'ff': {
    \ 'startFilter': v:true,
    \ }
  \ },
  \ 'sources': [{'name': 'dein'}],
  \ })

call ddu#custom#patch_local('home', {
  \ 'ui': 'ff',
  \ 'uiParams': {
    \ 'ff': {
    \ 'startFilter': v:true,
    \ },
  \ },
  \ 'sourceOptions': {
    \ 'file': {'path': expand('~')},
    \ },
  \ 'sources': [{'name': 'file'}],
  \ })

call ddu#custom#patch_local('register', {
  \ 'sources': [{'name': 'register'}],
  \ })

" call ddu#custom#patch_local('search', {
"     \ 'sources': [{
"     \     'name': 'rg',
"     \     'params': {'input': input('Pattern: ')}
"     \     }],
"     \ })

" }}}

" fuzzy finder keybinds {{{
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
  nnoremap <buffer><silent> v
  \ <Cmd>call ddu#ui#ff#do_action('itemAction',
  \ {'name': 'open', 'params': {'command': 'vsplit'}})<CR>

  " Open file with another tab.
  nnoremap <buffer><silent> t
  \ <Cmd>call ddu#ui#ff#do_action('itemAction',
  \ {'name': 'open', 'params': {'command': 'tabedit'}})<CR>

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

  " Wrap when moving to the beginning and end of a line
  nnoremap <silent><buffer><expr> j
  \ line('.') == line('$') ?
    \ 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
  \ line('.') == 1 ?
    \ 'G' : 'k'
endfunction
" }}}

" fuzzy finder filter keybinds {{{
function! s:ddu_ff_filter_keybind() abort
  inoremap <buffer><silent> <CR>
  \ <Esc><Cmd>close<CR>
  inoremap <buffer><silent> jj
  \ <Esc><Cmd>close<CR>
  inoremap <buffer><silent> <Esc>
  \ <Esc><Cmd>close<CR>

  nnoremap <buffer><silent> <CR>
  \ <Cmd>close<CR>
  nnoremap <buffer><silent> jj
  \ <Cmd>close<CR>
  nnoremap <buffer><silent> <Esc>
  \ <Esc><Cmd>close<CR>
endfunction
" }}}

" ddu auto commands {{{
augroup ddu_settings
  autocmd!
  autocmd FileType ddu-ff-filter call s:ddu_ff_filter_keybind()
  autocmd FileType ddu-ff call s:ddu_ff_keybind()
augroup END
" }}}
