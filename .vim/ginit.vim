" Configuration file for neovim-gtk

if exists('g:GtkGuiLoaded')
    let g:GuiInternalClipboard = 1
    call rpcnotify(1, 'Gui', 'Font', 'HackGenNerd Console 14')
    call rpcnotify(1, 'Gui', 'Option', 'Tabline', 0) 
    call rpcnotify(1, 'Gui', 'Option', 'Cmdline', 1)
    call rpcnotify(1, 'Gui', 'Command', 'SetCursorBlink', '10')
endif
