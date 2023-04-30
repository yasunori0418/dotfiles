" ddu-ff {{{
" Open file keybinds.
nnoremap <buffer><silent> <CR>
  \ <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
nnoremap <buffer> o
  \ <Cmd>call ddu#ui#ff#do_action('itemAction', {'name': 'open', 'params': {'command': 'drop'}})<CR>

" Open file with horizontal window.
nnoremap <buffer> s
  \ <Cmd>call ddu#ui#do_action('itemAction',
  \ #{name: 'open', params: #{command: 'split'}})<CR>

" Open file with vertical window.
nnoremap <buffer> v
  \ <Cmd>call ddu#ui#do_action('itemAction',
  \ #{name: 'open', params: #{command: 'vsplit'}})<CR>

" Open file with another tab.
nnoremap <buffer> t
  \ <Cmd>call ddu#ui#do_action('itemAction',
  \ #{name: 'open', params: #{command: 'tabedit'}})<CR>


" Multiple selection
nnoremap <buffer> <Space>
  \ <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>
nnoremap <buffer> *
  \ <Cmd>cal ddu#ui#do_action('toggleAllItems')<CR>


" fuzzy finder controll keybinds
" Open selection menu.
nnoremap <buffer> a
  \ <Cmd>call ddu#ui#do_action('chooseAction')<CR>

" Open filter Window.
nnoremap <buffer> i
  \ <Cmd>call ddu#ui#do_action('openFilterWindow')<CR>

" Open preview window.
nnoremap <buffer> p
  \ <Cmd>call ddu#ui#do_action('preview')<CR>

nnoremap <buffer> <C-l>
  \ <Cmd>call ddu#ui#do_action('refreshItems')<CR>

" Close ddu window.
nnoremap <buffer> q
  \ <Cmd>call ddu#ui#do_action('quit')<CR>
nnoremap <buffer> <Esc>
  \ <Cmd>call ddu#ui#do_action('quit')<CR>

" Wrap when moving to the beginning and end of a line
nnoremap <buffer><expr> j
  \ line('.') == line('$') ?
  \ 'gg' : 'j'
nnoremap <buffer><expr> k
  \ line('.') == 1 ?
  \ 'G' : 'k'
" }}}

" ddu-ff-filter {{{
" fuzzy finder filter keybinds on insert mode
inoremap <buffer> <CR>
  \ <Esc><Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>
inoremap <buffer> jj
  \ <Esc><Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>
inoremap <buffer> <Esc>
  \ <Esc><Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>

" fuzzy finder filter keybinds on normal mode
nnoremap <buffer> <CR>
  \ <Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>
nnoremap <buffer> q
  \ <Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>
nnoremap <buffer> jj
  \ <Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>
nnoremap <buffer> <Esc>
  \ <Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>

" }}}
