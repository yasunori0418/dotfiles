" Global source Options {{{
call ddu#custom#patch_global({
  \ 'uiOptions': {
    \ 'filer': {
      \ 'toggle': v:true,
      \ },
    \ },
  \ 'uiParams': {
    \ 'ff': {
      \ 'previewFloating': v:true,
      \ 'split': 'floating',
      \ 'prompt': '',
      \ 'filterSplitDirection': 'floating',
      \ 'displaySourceName': 'long',
      \ },
    \ 'filer': {
      \ 'split': 'vertical',
      \ 'splitDirection': 'topleft',
      \ 'winWidth': &columns /6,
      \ },
    \ },
  \ 'sourceOptions': {
    \ '_': {
      \ 'ignoreCase': v:true,
      \ 'matchers': ['matcher_substring'],
      \ },
    \ 'file': {
      \ 'matchers': ['matcher_substring'],
      \ 'columns': ['icon_filename'],
      \ },
    \ 'file_rec': {
      \ 'matchers': ['matcher_substring'],
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
  \ 'columnParams': {
    \ 'icon_filename': {
      \ 'span': 2,
      \ 'iconWidth': 2,
      \ 'defaultIcon': {
        \ 'icon': '',
        \ },
      \ },
    \ },
  \ })

" }}}

" UI:ff presets {{{
call ddu#custom#patch_local('current-ff', {
  \ 'ui': 'ff',
  \ 'uiParams': {
    \ 'ff': {
      \ 'startFilter': v:true,
      \ },
    \ },
  \ 'sources': [
      \ {'name': 'file_rec'},
      \ ],
  \ })

call ddu#custom#patch_local('dotfiles-ff', {
  \ 'ui': 'ff',
  \ 'uiParams': {
    \ 'ff': {
    \ 'startFilter': v:true,
    \ },
  \ },
  \ 'sourceOptions': {
    \ 'file_rec': {'path': expand('~/dotfiles')},
    \ },
  \ 'sources': [{'name': 'file_rec'}],
  \ })

call ddu#custom#patch_local('project-list-ff', {
  \ 'ui': 'ff',
  \ 'uiParams': {
    \ 'ff': {
    \ 'startFilter': v:true,
    \ },
  \ },
  \ 'sourceOptions': {
    \ 'file': {'path': expand('~/Project')},
    \ },
  \ 'sources': [{'name': 'file'}],
  \ })

call ddu#custom#patch_local('help-ff', {
  \ 'ui': 'ff',
  \ 'uiParams': {
    \ 'ff': {
      \ 'startFilter': v:true,
      \ },
    \ },
  \ 'sources': [{'name': 'help'}],
  \ })

call ddu#custom#patch_local('buffer-ff', {
  \ 'ui': 'ff',
  \ 'sources': [{'name': 'buffer'}],
  \ })

call ddu#custom#patch_local('plugin-list-ff', {
  \ 'ui': 'ff',
  \ 'uiParams': {
    \ 'ff': {
    \ 'startFilter': v:true,
    \ }
  \ },
  \ 'sources': [{'name': 'dein'}],
  \ })

call ddu#custom#patch_local('home-ff', {
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

call ddu#custom#patch_local('register-ff', {
  \ 'ui': 'ff',
  \ 'sources': [{'name': 'register'}],
  \ })

" call ddu#custom#patch_local('search', {
"     \ 'sources': [{
"     \     'name': 'rg',
"     \     'params': {'input': input('Pattern: ')}
"     \     }],
"     \ })

" }}}

" UI:ff keybinds {{{
"
function! s:ddu_ff_keybind() abort

  " Edit file.
  nnoremap <buffer><silent> <CR>
    \ <Cmd>call ddu#ui#ff#do_action('itemAction', {'name': 'open', 'params': {'command': 'drop'}})<CR>

  " Multiple selection.
  nnoremap <buffer><silent> <Space>
    \ <Cmd>call ddu#ui#ff#do_action('toggleSelectItem')<CR>

  " Open selection menu.
  nnoremap <buffer><silent> a
    \ <Cmd>call ddu#ui#ff#do_action('chooseAction')<CR>

  " Move directory.
  nnoremap <buffer><silent> c
    \ <Cmd>call ddu#ui#ff#do_action('itemAction', {'name': 'cd'})<CR>

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

" UI:ff-filter keybinds
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

" UI:filer presets {{{

call ddu#custom#patch_local('current-filer', {
  \ 'ui': 'filer',
  \ 'sourceOptions': {
    \ 'file': {'path': expand('%:p:h')},
    \ },
  \ 'sources': [{'name': 'file'}],
  \ 'actionOptions': {
    \ 'narrow': {'quit': v:false},
    \ },
  \ })


  "\ 'uiParams': {
  "  \ 'filer': {
  "    \ 'search': expand('#' . b:ddu_ui_filer_prev_bufnr . ':p'),
  "    \ },
  "  \ },

" }}}

" UI:filer keybinds {{{

function! s:ddu_filer_keybind() abort
  " Open of file or directory. {{{
  " Open file or expand directory when directory.
  " Directory is expanded in tree type.
  " If you select a file that is already open, go to the open screen.
  nnoremap <buffer><expr> <CR>
    \ ddu#ui#filer#is_directory() ?
    \ "<Cmd>call ddu#ui#filer#do_action('expandItem', {'mode': 'toggle'})<CR>" :
    \ "<Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'open', 'params': {'command': 'drop'}})<CR>"

  " Open file with vertical split.
  nnoremap <buffer> v
    \ <Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'open', 'params': {'command': 'vsplit'}})<CR>

  " Open file with horizontal split.
  nnoremap <buffer> s
    \ <Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'open', 'params': {'command': 'split'}})<CR>
  " }}}

  " Operation of file or directory {{{
  " Copy file or directory.
  nnoremap <buffer> C
    \ <Cmd>call ddu#ui#filer#multi_actions([
    \ ['itemAction', {'name': 'copy'}],
    \ ['clearSelectAllItems'],
    \ ])<CR>

  " Move file or directory.
  nnoremap <buffer> M
    \ <Cmd>call ddu#ui#filer#multi_actions([
    \ ['itemAction', {'name': 'move'}],
    \ ['clearSelectAllItems'],
    \ ])<CR>

  " Paste file or directory.
  nnoremap <buffer> P
    \ <Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'paste'})<CR>

  " Rename file or directory.
  nnoremap <buffer> R
    \ <Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'rename'})<CR>

  " Delete file or directory.
  nnoremap <buffer> [delete] <Nop>
  nmap <buffer> d [delete]
  nnoremap <buffer> [delete]d
    \ <Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'trash'})<CR>
  nnoremap <buffer> [delete]D
    \ <Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'delete'})<CR>

  " make new file or directory.
  nnoremap <buffer> N
    \ <Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'newFile'})<CR>
  " }}}

  " Path operation in filer. {{{
  " Yank path the file or directory.
  nnoremap <buffer> y
    \ <Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'yank'})<CR>
    \ <Cmd>echo 'Yanke path the ' . '"' . getreg('+') . '"'<CR>

  " Change current directory.
  nnoremap <buffer> c
    \ <Cmd>call Filer_change_dir()<CR>

  " Move to parent path.
  nnoremap <buffer> h
    \ <Cmd>call Filer_parent_dir()<CR>

  nnoremap <buffer> l
    \ <Cmd>call Filer_prev_dir()<CR>

  nnoremap <buffer> f
    \ <Cmd>call Filer_first_dir()<CR>

  " Move to home path.
  nnoremap <buffer> ~
    \ <Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'narrow', 'params': {'path': expand('~')}})<CR>
  " }}}

  " Other filer keybinds... {{{
  " select file action.
  nnoremap <buffer> a
    \ <Cmd>call ddu#ui#filer#do_action('chooseAction')<CR>

  nnoremap <buffer> o
    \ <Cmd>call ddu#ui#filer#do_action('expandItem', {'mode': 'toggle'})<CR>
  nnoremap <buffer> O
    \ <Cmd>call ddu#ui#filer#do_action('expandItem', {'maxLevel': -1})<CR>

  " multiple files selection
  nnoremap <buffer> <Space>
    \ <Cmd>call ddu#ui#filer#do_action('toggleSelectItem')<CR>
  nnoremap <buffer> *
    \ <Cmd>call ddu#ui#filer#do_action('toggleAllItems')<CR>

nnoremap <buffer> >
  \ <Cmd>call ddu#ui#filer#do_action('updateOptions', {
    \ 'sourceOptions': {
      \ 'file': {
        \ 'matchers': ToggleHidden('file'),
        \ },
      \},
    \})<CR>

  nnoremap <buffer> q
    \ <Cmd>call ddu#ui#filer#do_action('quit')<CR>
  nnoremap <buffer> <ESC>
    \ <Cmd>call ddu#ui#filer#do_action('quit')<CR>

  " Wrap when moving to the beginning and end of a line
  nnoremap <silent><buffer><expr> j
    \ line('.') == line('$') ?
    \ 'ggj' : 'j'
  nnoremap <silent><buffer><expr> k
    \ line('.') == 2 ?
    \ 'G' : 'k'

  " }}}
endfunction

" }}}

" Custom keybinds functions for UI:filer. {{{
" Moving directory paths. {{{
let g:ddu_filer_prev_dir = []
function! Filer_parent_dir() abort
  if b:ddu_ui_filer_path == '/'
    echo 'Cannot go back because it is the root directory.'
    return
  endif
  call add(g:ddu_filer_prev_dir, b:ddu_ui_filer_path)
  call ddu#ui#filer#do_action('itemAction', {'name': 'narrow', 'params': {'path': '..'}})
endfunction

function! Filer_change_dir() abort
  call add(g:ddu_filer_prev_dir, b:ddu_ui_filer_path)
  call ddu#ui#filer#do_action('itemAction', {'name': 'narrow'})
endfunction

function! Filer_prev_dir() abort
  if empty(g:ddu_filer_prev_dir)
    echo 'Not found previous directory.'
    return
  endif
  let prev_dir_count = len(g:ddu_filer_prev_dir) - 1
  let prev_dir_path = g:ddu_filer_prev_dir[prev_dir_count]
  call remove(g:ddu_filer_prev_dir, prev_dir_count)
  call ddu#ui#filer#do_action('itemAction', {'name': 'narrow', 'params': {'path': prev_dir_path}})
endfunction

function! Filer_first_dir() abort
  if empty(g:ddu_filer_prev_dir)
    echo "Maybe here is the first directory..."
    return
  endif
  let first_dir = g:ddu_filer_prev_dir[0]
  let index_max_value = len(g:ddu_filer_prev_dir) - 1
  call remove(g:ddu_filer_prev_dir, 0, index_max_value)
  call ddu#ui#filer#do_action('itemAction', {'name': 'narrow', 'params': {'path': first_dir}})
endfunction
" }}}

" Toggle show hidden file.
function! ToggleHidden(name)
  let current = ddu#custom#get_current(b:ddu_ui_name)
  let source_options = get(current, 'sourceOptions', {})
  let source_options_name = get(source_options, a:name, {})
  let matchers = get(source_options_name, 'matchers', [])
  return index(matchers, 'matcher_hidden') >= 0 ? ['matcher_substring'] : ['matcher_substring', 'matcher_hidden']
endfunction

" }}}

" ddu auto commands {{{

augroup ddu_settings
  autocmd!
  autocmd FileType ddu-ff-filter call s:ddu_ff_filter_keybind()
  autocmd FileType ddu-ff call s:ddu_ff_keybind()
  autocmd FileType ddu-filer call s:ddu_filer_keybind()
augroup END

" }}}
