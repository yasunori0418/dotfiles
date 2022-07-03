if &compatible
  set nocompatible
endif

" dein directory {{{

" dein base directory.
let s:dein_dir = expand('~/.cache/dein')

" dein repository directory.
let s:dein_repo = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" }}}


" vim settings directory. {{{

" vim setting directory.
let g:base_dir = fnamemodify(expand('<sfile>'), ':h') .. '/'

" vimrcs directory.
let s:vimrcs_dir = g:base_dir .. 'rc/'

" plugins toml-file directory.
let s:toml_dir = g:base_dir ..'toml/'
let s:toml_files = systemlist('ls ' .. s:toml_dir .. '*.toml')
" }}}


" dein installation check {{{

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo
  endif
  execute 'set runtimepath^=' . s:dein_repo
endif
" }}}


" dein options {{{

let g:dein#install_progress_type = 'floating'
let g:dein#enable_notification = v:true
let g:dein#auto_recache = v:true
let g:dein#lazy_rplugins = v:true

" GitHub apt token file.
let s:github_pat = g:base_dir .. 'github_pat'
if filereadable(s:github_pat)
  let g:dein#install_github_api_token = readfile(s:github_pat)[0]
  let g:exists_github_pat = v:true
else
  let g:exists_github_pat = v:false
endif

" }}}


" Begin settings {{{
if dein#min#load_state(s:dein_dir)

  " dein inline_vimrcs setting.{{{

  let g:dein#inline_vimrcs = ['option.vim', 'keybind.vim']

  " Use neovide
  if exists("g:neovide")
    call add(g:dein#inline_vimrcs, 'neovide.vim')
  endif


  call map(g:dein#inline_vimrcs, { _, val -> s:vimrcs_dir .. val })

  " }}}

  call dein#begin(s:dein_dir)

  for toml_file in s:toml_files
    if toml_file == s:toml_dir .. 'dein.toml'
      call dein#load_toml(toml_file, {'lazy': 0})
    else
      call dein#load_toml(toml_file, {'lazy': 1})
    endif
  endfor

  " Test local plugins
  " call dein#local('~/Project', {'lazy': 1, 'on_source': 'skkeleton'}, ['lightline-skk'])

  " end settings
  call dein#end()
  call dein#save_state()
endif
" }}}


" Plugin installation check {{{
if dein#check_install()
  call dein#install()
endif
" }}}


" Check for plugin updates on github graphQL api.{{{
function! s:dein_update() abort
  if g:exists_github_pat
    echo 'exists github_pat'
    call dein#check_update(v:true)
  else
    echo 'not exists github_pat'
    call dein#update()
  endif
endfunction

command! DeinUpdate call s:dein_update()
" }}}


" dein.vim remove plugins.{{{
function! s:dein_check_uninstall() abort
  let l:remove_plugins = dein#check_clean()
  if len(l:remove_plugins) > 0
    for l:remove_plugin in l:remove_plugins
      echo l:remove_plugin
    endfor
    echo 'Would you like to remove those plugins?'
    echon '[Y/n]'
    if getcharstr() == 'y'
      call map(l:remove_plugins, "delete(v:val, 'rf')")
      call dein#recache_runtimepath()
      echo 'Remove Plugins ...done!'
    else 
      echo 'Remove Plugins ...abort!'
    endif
  else
    echo 'There are no plugins to remove.'
  endif
endfunction

command! DeinRemove call s:dein_check_uninstall()
" }}}

" ファイル形式別プラグインの有効
filetype plugin indent on
" シンタックスハイライトの有効
syntax enable
