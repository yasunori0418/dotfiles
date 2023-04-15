" ddu-filer {{{
" Open of file or directory.
" Open file or expand directory when directory.
" Directory is expanded in tree type.
" If you select a file that is already open, go to the open screen.
nnoremap <buffer><expr> <CR>
  \ ddu#ui#get_item()['isTree'] ?
  \ "<Cmd>call ddu#ui#do_action('expandItem', {'mode': 'toggle'})<CR>" :
  \ "<Cmd>call ddu#ui#do_action('itemAction', {'name': 'open', 'params': {'command': 'drop'}})<CR>"

" Open file with vertical split.
nnoremap <buffer> v
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'open', 'params': {'command': 'vsplit'}})<CR>

" Open file with horizontal split.
nnoremap <buffer> s
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'open', 'params': {'command': 'split'}})<CR>

" Open file with another tab window.
nnoremap <buffer> t
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'open', 'params': {'command': 'tabedit'}})<CR>

nnoremap <buffer> p
  \ <Cmd>call ddu#ui#do_action('preview')<CR>


" Operation of file or directory keybinds
" Copy file or directory.
nnoremap <buffer> C
  \ <Cmd>call ddu#ui#multi_actions([
  \ ['itemAction', {'name': 'copy'}],
  \ ['clearSelectAllItems'],
  \ ])<CR>

" Move file or directory.
nnoremap <buffer> M
  \ <Cmd>call ddu#ui#multi_actions([
  \ ['itemAction', {'name': 'move'}],
  \ ['clearSelectAllItems'],
  \ ])<CR>

" Paste file or directory.
nnoremap <buffer> P
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'paste'})<CR>

" Rename file or directory.
nnoremap <buffer> R
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'rename'})<CR>

" Delete file or directory.
nmap <buffer> d <Plug>(delete)
nmap <buffer> <Plug>(delete)d
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'trash'})<CR>
nmap <buffer> <Plug>(delete)D
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'delete'})<CR>

" make new file or directory.
nnoremap <buffer> N
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'newFile'})<CR>

" Path operation in filer.
" Yank path the file or directory.
nnoremap <buffer> y
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'yank'})<CR>
  \ <Cmd>echo 'Yank path the "' . getreg('+') . '"'<CR>


" Changes directory keybinds
" Change current directory.
nnoremap <buffer> c
  \ <Cmd>call Filer_change_dir()<CR>

" Move to parent directory.
nnoremap <buffer> h
  \ <Cmd>call Filer_parent_dir()<CR>

" Move to previous directory.
nnoremap <buffer> l
  \ <Cmd>call Filer_prev_dir()<CR>

" Move to first directory.
nnoremap <buffer> f
  \ <Cmd>call Filer_first_dir()<CR>

" Move to directory of inputed path.
nnoremap <buffer> I
  \ <Cmd>call Filer_input_dir()<CR>

" Move to home path.
nnoremap <buffer> ~
  \ <Cmd>call ddu#ui#do_action('itemAction', {'name': 'narrow', 'params': {'path': expand('~')}})<CR>


" Other filer keybinds...
" select file action.
nnoremap <buffer> a
  \ <Cmd>call ddu#ui#do_action('chooseAction')<CR>

nnoremap <buffer> o
  \ <Cmd>call ddu#ui#do_action('expandItem', {'mode': 'toggle'})<CR>
nnoremap <buffer> O
  \ <Cmd>call ddu#ui#do_action('expandItem', {'maxLevel': -1})<CR>

" multiple files selection
nnoremap <buffer> <Space>
  \ <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>
nnoremap <buffer> *
  \ <Cmd>call ddu#ui#do_action('toggleAllItems')<CR>

nnoremap <buffer> >
  \ <Cmd>call ddu#ui#do_action('updateOptions', {
    \ 'sourceOptions': {
      \ 'file': {
        \ 'matchers': ToggleHidden('file'),
        \ },
      \ },
    \ })<CR>

nnoremap <buffer> / <Cmd>call ddu#start({
  \ 'name': 'current-ff',
  \ 'sourceOptions': {
    \ 'file_rec': {'path': fnamemodify(b:ddu_ui_filer_path, ':p:h')},
    \ },
  \ })<CR>

nnoremap <buffer> <C-l>
  \ <Cmd>call ddu#ui#do_action('checkItems')<CR>

nnoremap <buffer> q
  \ <Cmd>call ddu#ui#do_action('quit')<CR>
nnoremap <buffer> <ESC>
  \ <Cmd>call ddu#ui#do_action('quit')<CR>

" Wrap when moving to the beginning and end of a line
nnoremap <silent><buffer><expr> j
  \ line('.') == line('$') ?
  \ 'ggj' : 'j'
nnoremap <silent><buffer><expr> k
  \ line('.') == 2 ?
  \ 'G' : 'k'


" UI:filer functions of custom keybind.
" Moving directory paths.

let g:ddu_ui_filer_prev_dirs = {}
function! Filer_parent_dir() abort
  if b:ddu_ui_filer_path == '/'
    echo 'Cannot go back because it is the root directory.'
    return
  endif

  if !exists('g:ddu_ui_filer_prev_dirs[b:ddu_ui_name]')
    let g:ddu_ui_filer_prev_dirs[b:ddu_ui_name] = []
  endif

  call add(g:ddu_ui_filer_prev_dirs[b:ddu_ui_name], b:ddu_ui_filer_path)
  call ddu#ui#do_action('itemAction', {'name': 'narrow', 'params': {'path': '..'}})
endfunction

function! Filer_change_dir() abort
  if !exists('g:ddu_ui_filer_prev_dirs[b:ddu_ui_name]')
    let g:ddu_ui_filer_prev_dirs[b:ddu_ui_name] = []
  endif

  call add(g:ddu_ui_filer_prev_dirs[b:ddu_ui_name], b:ddu_ui_filer_path)
  call ddu#ui#do_action('itemAction', {'name': 'narrow'})
endfunction

function! Filer_prev_dir() abort
  if exists('g:ddu_ui_filer_prev_dirs[b:ddu_ui_name]')
    if empty(g:ddu_ui_filer_prev_dirs[b:ddu_ui_name])
      echo 'Not found previous directory.'
      return
    endif
  else
    echo 'The directory has not been changed with this filer.'
    let g:ddu_ui_filer_prev_dirs[b:ddu_ui_name] = []
    return
  endif
  let prev_dir_count = len(g:ddu_ui_filer_prev_dirs[b:ddu_ui_name]) - 1
  let prev_dir_path = g:ddu_ui_filer_prev_dirs[b:ddu_ui_name][prev_dir_count]
  call remove(g:ddu_ui_filer_prev_dirs[b:ddu_ui_name], prev_dir_count)
  call ddu#ui#do_action('itemAction', {'name': 'narrow', 'params': {'path': prev_dir_path}})
endfunction

function! Filer_first_dir() abort
  if exists('g:ddu_ui_filer_prev_dirs[b:ddu_ui_name]')
    if empty(g:ddu_ui_filer_prev_dirs[b:ddu_ui_name])
      echo "Maybe here is the first directory..."
      return
    endif
  else
    echo 'The directory has not been changed with this filer.'
    let g:ddu_ui_filer_prev_dirs[b:ddu_ui_name] = []
    return
  endif
  let first_dir = g:ddu_ui_filer_prev_dirs[b:ddu_ui_name][0]
  let index_max_value = len(g:ddu_ui_filer_prev_dirs[b:ddu_ui_name]) - 1
  call remove(g:ddu_ui_filer_prev_dirs[b:ddu_ui_name], 0, index_max_value)
  call ddu#ui#do_action('itemAction', {'name': 'narrow', 'params': {'path': first_dir}})
endfunction

function! Filer_input_dir() abort
  if exists('g:ddu_ui_filer_prev_dirs[b:ddu_ui_name]')
    if !empty(g:ddu_ui_filer_prev_dirs[b:ddu_ui_name])
      call remove(g:ddu_ui_filer_prev_dirs[b:ddu_ui_name], 0, len(g:ddu_ui_filer_prev_dirs[b:ddu_ui_name]) - 1)
    endif
  else
    echo 'The directory has not been changed with this filer.'
    let g:ddu_ui_filer_prev_dirs[b:ddu_ui_name] = []
    return
  endif
  let input_dir = fnamemodify(input('New cwd: ', b:ddu_ui_filer_path, 'dir'), ':p')
  call ddu#ui#do_action('itemAction', {'name': 'narrow', 'params': {'path': input_dir}})
endfunction

" Toggle show hidden file.
function! ToggleHidden(name)
  let current = ddu#custom#get_current(b:ddu_ui_name)
  let source_options = get(current, 'sourceOptions', {})
  let source_options_name = get(source_options, a:name, {})
  let matchers = get(source_options_name, 'matchers', [])
  return empty(matchers) ? ['matcher_hidden'] : []
endfunction


autocmd TabEnter,CursorHold,FocusGained <buffer> call ddu#ui#do_action('checkItems')
" }}}
