## Remove keybinds of default.
bindkey -rpM emacs "^X"
bindkey -rpM emacs "^["
bindkey -rM  emacs "^G"
bindkey -rM  emacs "^V"
bindkey -rM  emacs "^Q"
bindkey -rM  emacs "^S"
bindkey -rM  emacs "^T"
bindkey -rM  emacs "^@"
bindkey -rM  emacs "^J"
bindkey -rM  emacs "^O"
bindkey -rM  emacs "^R"

bindkey "^[[200~" bracketed-paste # keybinds for deol

## Remaining keybinds of default.
# bindkey "^A" beginning-of-line
# bindkey "^B" backward-char
# bindkey "^D" delete-char-or-list
# bindkey "^E" end-of-line
# bindkey "^F" forward-char
# bindkey "^H" backward-delete-char
# bindkey "^I" expand-or-complete
# bindkey "^K" kill-line
# bindkey "^L" clear-screen
# bindkey "^M" accept-line
# bindkey "^N" down-line-or-history
# bindkey "^P" up-line-or-history
# bindkey "^U" kill-whole-line
# bindkey "^W" backward-kill-word
# bindkey "^Y" yank
# bindkey "^_" undo
# bindkey "^?" backward-delete-char # これがbackspaceらしい

################################################################
#                 Additional keybinds                          #
################################################################

bindkey "^O" edit-command-line
bindkey "^[[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)

# zeno keybinds
bindkey " "  zeno-auto-snippet
bindkey "^I" zeno-completion
bindkey "^R" zeno-history-selection
bindkey '^X' zeno-insert-snippet
bindkey '^G' zeno-ghq-cd
