function! Search_repo_root() abort
  let repo_root = systemlist('git root')[0]
  if v:shell_error != 0
    return expand('%:p:h')
  endif
  return repo_root
endfunction



nnoremap [ff] <Nop>
nmap <Space>d [ff]
nnoremap [ff]a <Cmd>call ddu#start({
  \ 'name': 'current-ff',
  \ 'sourceOptions': {
    \ 'file_rec': {'path': Search_repo_root()},
    \ },
  \ })<CR>
nnoremap [ff]d <Cmd>call ddu#start({'name': 'dotfiles-ff'})<CR>
nnoremap [ff]h <Cmd>call ddu#start({'name': 'help-ff'})<CR>
nnoremap [ff]b <Cmd>call ddu#start({'name': 'buffer-ff'})<CR>
nnoremap [ff]P <Cmd>call ddu#start({'name': 'plugin-list-ff'})<CR>
nnoremap [ff]p <Cmd>call ddu#start({'name': 'project-list-ff'})<CR>
nnoremap [ff]~ <Cmd>call ddu#start({'name': 'home-ff'})<CR>
nnoremap [ff]r <Cmd>call ddu#start({'name': 'register-ff'})<CR>
nnoremap [ff]s <Cmd>call ddu#start({
  \ 'name': 'search-ff',
  \ 'ui': 'ff',
  \ 'uiParams': {
    \ 'ff': {
      \ 'startFilter': v:true,
      \ },
    \ },
  \ 'sources': [{
    \ 'name': 'rg',
    \ 'params': {'input': input('Pattern: ')},
    \ }],
  \ })<CR>
nnoremap [ff]m <Cmd>call ddu#start({'name': 'mark_list-ff'})<CR>
command! DeinUpdateFF call ddu#start({'name': 'dein_update-ff'})

nnoremap [filer] <Nop>
nmap <Space>f [filer]
nnoremap [filer]a <Cmd>call ddu#start({
  \ 'name': 'current-filer',
  \ 'sourceOptions': {
    \ 'file': {'path': Search_repo_root()},
    \ },
  \ })<CR>
nnoremap [filer]d <Cmd>call ddu#start({'name': 'dotfiles-filer'})<CR>
nnoremap [filer]h <Cmd>call ddu#start({'name': 'home-filer'})<CR>
