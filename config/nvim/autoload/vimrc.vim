
" My helper functions
function! vimrc#clear_register() abort
  let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
  for r in regs
    call setreg(r, [])
  endfor
endfunction

function! vimrc#read_pat(path) abort
  let s:pat_path = a:path
  if filereadable(s:pat_path)
    return [v:true, readfile(s:pat_path)[0]]
  endif
  return [v:false, 'Can not read pat file.']
endfunction

function! vimrc#is_github_pat() abort
  let l:result_read_pat = vimrc#read_pat(g:base_dir . 'github_pat')
  if l:result_read_pat[0]
    let g:dein#install_github_api_token = l:result_read_pat[1]
    return v:true
  endif
  return v:false
endfunction

function! vimrc#search_repo_root() abort
  let repo_root = systemlist('git root')[0]
  if v:shell_error != 0
    return expand('%:p:h')
  endif
  return repo_root
endfunction

function! vimrc#signcolumn() abort
  silent!
  if &number
    set nonumber norelativenumber
    Gitsigns toggle_linehl
  else
    set number relativenumber
    Gitsigns toggle_linehl
  endif
endfunction

" dein feature expand functions
function! vimrc#dein_update(bang_flg) abort
  if vimrc#is_github_pat() && a:bang_flg == 0
    lua vim.notify('exists github_pat', 'info')
    call dein#check_update(v:true)
  elseif a:bang_flg
    lua vim.notify('use bang flag', 'info')
    call dein#update()
  else
    lua vim.notify('not exists github_pat', 'info')
    call dein#update()
  endif
endfunction

function! vimrc#dein_check_uninstall() abort
  let remove_plugins = dein#check_clean()
  if len(l:remove_plugins) > 0
    for remove_plugin in remove_plugins
      echo remove_plugin
    endfor
    echo 'Would you like to remove those plugins?'
    echon '[Y/n]'
    if getcharstr() ==? 'y'
      call map(remove_plugins, "delete(v:val, 'rf')")
      call dein#recache_runtimepath()
      echo 'Remove Plugins ...done!'
    else 
      echo 'Remove Plugins ...abort!'
    endif
  else
    echo 'There are no plugins to remove.'
  endif
endfunction

function! vimrc#lightline_git_branch() abort
  if gitbranch#name() ==# ''
    return ''
  else
    if &ambiwidth =~# 'single'
      return ' ' . gitbranch#name()
    else
      return '' . gitbranch#name()
    endif
  endif
endfunction

function! vimrc#lightline_custom_mode() abort
  if lightline#mode() ==# 'INSERT' || lightline#mode() ==# 'COMMAND' || lightline#mode() ==# 'REPLACE'
    if get(g:, 'loaded_skkeleton') == 0
      return lightline#mode()
    endif

    if skkeleton#mode() !=# ''
      return lightline#mode() . '-SKK'
    endif

  endif

  return lightline#mode()
endfunction


" skkeleton default settings
function! vimrc#skkeleton_init() abort
  call skkeleton#config({
    \ 'eggLikeNewline': v:true,
    \ 'globalDictionaries': [['~/.skk/skk_dict_merged', 'euc-jp'], ['~/.skk/SKK-JISYO.emoji', 'utf-8']],
    \ 'userJisyo': '~/.skk/skkeleton',
    \ })

  call skkeleton#register_kanatable('rom', {
    \ 'jj': 'escape',
    \ "z\<Space>": ["\u3000", ''],
    \ '~': ['～', ''],
    \ 'z0': ["\u25CB", ''],
    \ '(': ['（', ''],
    \ ')': ['）', ''],
    \ })

  call vimrc#L2X_Keymap()

endfunction

function! vimrc#skkeleton_pre() abort
  " Overwrite sources
  let s:prev_buffer_config = ddc#custom#get_buffer()
  call ddc#custom#patch_buffer('sources', ['skkeleton'])
endfunction

function! vimrc#skkeleton_post() abort
  " Restore sources
  call ddc#custom#set_buffer(s:prev_buffer_config)
endfunction

" skkeleton L2X function.
function! vimrc#L2X_Keymap() abort
  call skkeleton#register_kanatable('rom', vimrc#L2X_table())
  call skkeleton#register_keymap('input', 'x', 'disable')
  call skkeleton#register_keymap('input', 'X', 'zenkaku')
  call skkeleton#register_kanatable('rom', {'<s-l>': ['L', '']}, v:false)
endfunction

function! vimrc#L2X_table() abort

  let s:rom_table = {}
  let s:disable_l_nexts = split('bcdfghjkmnpqrsvxzBCDFGHJKMNPQRSVXZ,./1234567890-+=`~;:[]{}()<>!@#$%^&*_\"', '\zs')
  call add(s:disable_l_nexts, "'")
  call map(s:disable_l_nexts, {_, val -> 'l' . val})

  for s:disable_l_next in s:disable_l_nexts
    let s:rom_table[s:disable_l_next] = ['', '']
  endfor

  let s:enable_l_converts = {
    \ 'la': ['ぁ', ''],
    \ 'li': ['ぃ', ''],
    \ 'lu': ['ぅ', ''],
    \ 'le': ['ぇ', ''],
    \ 'lo': ['ぉ', ''],
    \ 'll': ['っ', 'l'],
    \ 'ltu': ['っ', ''],
    \ 'ltsu': ['っ', ''],
    \ 'lwa': ['ゎ', ''],
    \ 'lwe': ['ゑ', ''],
    \ 'lwi': ['ゐ', ''],
    \ 'lya': ['ゃ', ''],
    \ 'lyo': ['ょ', ''],
    \ 'lyu': ['ゅ', ''],
    \ }

  for s:item in items(s:enable_l_converts)
    let s:rom_table[s:item[0]] = s:item[1]
  endfor

  let s:disable_x_converts = {
    \ 'xa': ['', ''],
    \ 'xi': ['', ''],
    \ 'xu': ['', ''],
    \ 'xe': ['', ''],
    \ 'xo': ['', ''],
    \ 'xx': ['', ''],
    \ 'xtu': ['', ''],
    \ 'xtsu': ['', ''],
    \ 'xwa': ['', ''],
    \ 'xwe': ['', ''],
    \ 'xwi': ['', ''],
    \ 'xya': ['', ''],
    \ 'xyo': ['', ''],
    \ 'xyu': ['', ''],
    \ }

  for s:item in items(s:disable_x_converts)
    let s:rom_table[s:item[0]] = s:item[1]
  endfor

  return s:rom_table
endfunction


" ddc extra functions
" https://github.com/Shougo/shougo-s-github/blob/master/vim/rc/ddc.toml#L190-L226
function! vimrc#commandline_pre(mode) abort
  " NOTE: It disables default command line completion!
  set wildchar=<C-t>
  set wildcharm=<C-t>

  cnoremap <expr><buffer> <Tab>
  \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
  \ exists('b:prev_buffer_config') ?
  \ ddc#map#manual_complete() : "\<C-t>"

  " Overwrite sources
  if !exists('b:prev_buffer_config')
    let b:prev_buffer_config = ddc#custom#get_buffer()
  endif

  if a:mode ==# ':'
    call ddc#custom#patch_buffer('keywordPattern', '[0-9a-zA-Z_:#-]*')
  endif

  augroup user_ddc_cmdline_autocmd
    autocmd!
    autocmd User DDCCmdlineLeave ++once call vimrc#commandline_post()
    autocmd InsertEnter <buffer> ++once call vimrc#commandline_post()
  augroup END

  call ddc#enable_cmdline_completion()
endfunction

function! vimrc#commandline_post() abort
  silent! cunmap <buffer> <Tab>

  " Restore sources
  if exists('b:prev_buffer_config')
    call ddc#custom#set_buffer(b:prev_buffer_config)
    unlet b:prev_buffer_config
  else
    call ddc#custom#set_buffer({})
  endif

  set wildcharm=<Tab>
endfunction

function! vimrc#ddc_change_fileter(bang_flg, filter_name) abort
  if a:filter_name ==# 'normal'
    call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
        \ 'ignoreCase': v:true,
        \ 'matchers': ['matcher_head', 'matcher_length'],
        \ 'sorters': ['sorter_rank'],
        \ 'converters': ['converter_remove_overlap'],
        \ },
      \ })
  elseif a:filter_name ==# 'fuzzy'
    call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
        \ 'ignoreCase': v:true,
        \ 'matchers': ['matcher_fuzzy'],
        \ 'sorters': ['sorter_fuzzy'],
        \ 'converters': ['converter_fuzzy'],
        \ },
      \ })
  endif
  if a:bang_flg == 1
    echo ddc#custom#get_global()['sourceOptions']['_']
  endif
endfunction

" vim-molder function
function! vimrc#molder_init() abort
  if isdirectory(expand('%:p'))
    call dein#source('vim-molder')
    call molder#init()
    autocmd! vimrc_molder
  endif
endfunction

function! vimrc#molder_change_cwd() abort
  if &filetype ==# 'molder'
    let molder_cwd = substitute(bufname('%'), expand('~'), '~', '')
    let molder_cwd = substitute(molder_cwd, '/$', '', '')
    call chdir(molder_cwd)
    echomsg 'Change current working directory to [' . molder_cwd . ']'
  endif
endfunction
