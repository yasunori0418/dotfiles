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
let g:base_dir = fnamemodify(expand('<sfile>'), ':h') . '/'

" vimrcs directory.
let s:vimrcs_dir = g:base_dir . 'rc/'

" plugins toml-file directory.
let s:toml_dir = g:base_dir . 'toml/'
let s:dein_toml = 'dein.toml'
let s:lazy_toml = 'lazy.toml'
let s:ddc_toml = 'ddc.toml'
let s:ddu_toml = 'ddu.toml'
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
let g:dein#install_check_remote_threshold = 24 * 60 * 60

" }}}

" Begin settings {{{
if dein#min#load_state(s:dein_dir)

  " dein inline_vimrcs setting.{{{

  let g:dein#inline_vimrcs = ['options.vim', 'keybinds.vim']

  " Use neovide
  if exists("g:neovide")
    call add(g:dein#inline_vimrcs, 'neovide.vim')
  endif


  call map(g:dein#inline_vimrcs, { _, val -> s:vimrcs_dir .. val })

  " }}}

  call dein#begin(s:dein_dir)

  call dein#load_toml(s:toml_dir . s:dein_toml,   {'lazy': 0})
  call dein#load_toml(s:toml_dir . s:lazy_toml,   {'lazy': 1})
  call dein#load_toml(s:toml_dir . s:ddc_toml,    {'lazy': 1})
  call dein#load_toml(s:toml_dir . s:ddu_toml,    {'lazy': 1})

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

" ファイル形式別プラグインの有効
filetype plugin indent on
" シンタックスハイライトの有効
syntax enable
