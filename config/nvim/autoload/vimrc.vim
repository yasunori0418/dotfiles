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
