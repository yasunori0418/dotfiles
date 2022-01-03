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

let g:dein#install_progress_type = 'title'
let g:dein#enable_notification = v:true
let g:dein#auto_recache = v:true
let g:dein#lazy_rplugins = v:true

" }}}


" Begin settings {{{
if dein#min#load_state(s:dein_dir)

    " dein inline_vimrcs setting.{{{

    let g:dein#inline_vimrcs = ['option.vim', 'keybind.vim']

    call map(g:dein#inline_vimrcs, { _, val -> s:vimrcs_dir .. val })

    " }}}

    call dein#begin(s:dein_dir)

    " toml files.{{{
    let s:dein_toml = s:toml_dir .. 'dein.toml'
    let s:dein_lazy_toml = s:toml_dir .. 'lazy.toml'
    let s:dein_ft_toml = s:toml_dir .. 'filetype.toml'
    let s:dein_denops_toml = s:toml_dir .. 'denops.toml'
    let s:dein_lsp_toml = s:toml_dir .. 'lsp.toml'

    " read toml and cache
    call dein#load_toml(s:dein_toml, {'lazy': 0})
    call dein#load_toml(s:dein_lazy_toml, {'lazy': 1})
    call dein#load_toml(s:dein_ft_toml, {'lazy': 1})
    call dein#load_toml(s:dein_denops_toml, {'lazy': 1})
    call dein#load_toml(s:dein_lsp_toml, {'lazy': 1})
    " }}}

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





" Neovide settings{{{

if exists('g:neovide')
    " Font and size settings when using GUI
    set guifont=Cica:h14

    " East asia ambigunous width ploblem.
    set ambiwidth=double

    " Refresh rate
    let g:neovide_refresh_rate=60

    " Cursor settings{{{
    
    " Animation length
    let g:neovide_cursor_animation_length=0

    " Animation trail length
    let g:neovide_cursor_trail_length=0

    " }}}


    " Lightline separator{{{
    " Separator
    let g:lightline.separator = {}
    let g:lightline.separator.left = ''
    let g:lightline.separator.right = ''

    " subseparator
    let g:lightline.subseparator = {}
    let g:lightline.subseparator.left = ''
    let g:lightline.subseparator.right = ''
    " }}}

endif

" }}}



" Nvui settings.{{{
if exists('g:nvui')
    " Font and size settings when using GUI
    set guifont=Cica:h14

    " East asia ambigunous width ploblem.
    set ambiwidth=double

    " Nvui cmdline customize.
    NvuiCmdCenterXPos 0.5
    NvuiCmdCenterYPos 0.5
    NvuiCmdFontFamily Cica
    NvuiCmdFontSize 20
    NvuiCmdPadding 2
    NvuiCmdBigFontScaleFactor 1

    " Nvui multigrid customize.
    NvuiScrollAnimationDuration 0.5

    " Nvui cursor customize.
    NvuiCursorAnimationDuration 0.5

    " Hide the mouse cursor as you type.
    NvuiCursorHideWhileTyping v:true

    " Lightline separator{{{
    " Separator
    let g:lightline.separator = {}
    let g:lightline.separator.left = ''
    let g:lightline.separator.right = ''

    " subseparator
    let g:lightline.subseparator = {}
    let g:lightline.subseparator.left = ''
    let g:lightline.subseparator.right = ''
    " }}}

endif

" }}

