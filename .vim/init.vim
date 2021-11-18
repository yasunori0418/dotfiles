" dein.vim setting.
source ~/dotfiles/.vim/rc/dein.vim

" Startup initial settings.
source ~/dotfiles/.vim/rc/option.vim

" Key bind settings.
source ~/dotfiles/.vim/rc/keybind.vim

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

