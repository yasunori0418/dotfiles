function! vimrc#clear_register() abort
  let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
  for r in regs
    call setreg(r, [])
  endfor
endfunction

" dein commands {{{
function! vimrc#is_github_pat() abort
  let s:github_pat = g:base_dir . 'github_pat'
  if filereadable(s:github_pat)
    let g:dein#install_github_api_token = readfile(s:github_pat)[0]
    return v:true
  else
    return v:false
  endif
endfunction

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
" }}}

" component function. {{{
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
    else
      return lightline#mode()
    endif
  else
    return lightline#mode()
  endif
endfunction

" }}}

" skkeleton default settings {{{
function! vimrc#skkeleton_init() abort
  call skkeleton#config({
    \ 'eggLikeNewline': v:true,
    \ 'userJisyo': '~/.cache/nvim/skkeleton'
    \ })

  call skkeleton#register_kanatable('rom', {
    \ 'jj': 'escape',
    \ "z\<Space>": ["\u3000", ''],
    \ '~': ['～', ''],
    \ 'z0': ["\u25CB", ''],
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
" }}}

" skkeleton L2X function. {{{
function! vimrc#L2X_Keymap() abort
  call skkeleton#register_kanatable('rom', vimrc#L2X_table())

  call skkeleton#register_keymap('input', 'x', 'disable')
  call skkeleton#register_keymap('input', 'X', 'zenkaku')
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
" }}}

" Command line keybinds {{{
function! vimrc#cmdline_pre(mode) abort
  call dein#source('ddc.vim')

  cnoremap <expr> <TAB>
    \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' : 
    \ ddc#map#manual_complete()
  cnoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>

  " Note: It disables default command line completion!
  set wildchar=<C-t>

  " Overwrite sources.
  if !exists('b:prev_buffer_config')
    let b:prev_buffer_config = ddc#custom#get_buffer()
  endif
  if a:mode ==# ':'
    call ddc#custom#patch_buffer('cmdlineSources', 
      \ ['cmdline', 'cmdline-history', 'file', 'around'])
    call ddc#custom#patch_buffer('keywordPattern', '[0-9a-zA-Z_:#]*')
  else
    call ddc#custom#patch_buffer('cmdlineSources',
      \ ['around', 'line'])
  endif

  augroup ddc_cmdline_autocmd
    autocmd!
    autocmd User DDCmdlineLeave ++once call Cmdline_post()
    autocmd InsertEnter <buffer> ++once call Cmdline_post()
  augroup END

  " Enable command line completion.
  call ddc#enable_cmdline_completion()
  call ddc#enable()
endfunction

function! vimrc#cmdline_post() abort
  " Restore sources.
  if exists('b:prev_buffer_config')
    call ddc#custom#set_buffer(b:prev_buffer_config)
    unlet b:prev_buffer_config
  else
    call ddc#custom#set_buffer({})
  endif

  set wildchar=<TAB>
endfunction
" }}}
