" Neovim-gtk settings{{{
if exists('g:GtkGuiLoaded')
    let g:GuiInternalClipboard = 1
    call rpcnotify(1, 'Gui', 'Font', 'Cica 14')
    set ambiwidth=double
    call rpcnotify(1, 'Gui', 'Option', 'Tabline', 0) 
    call rpcnotify(1, 'Gui', 'Option', 'Cmdline', 0)
    call rpcnotify(1, 'Gui', 'Command', 'SetCursorBlink', '10')
endif
" }}}
