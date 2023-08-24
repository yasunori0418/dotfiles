## Remove keybinds of default.
bindkey -rpM emacs "^X"
bindkey -rpM emacs "^["
bindkey -rM  emacs "^G"
bindkey -rM  emacs "^?"
bindkey -rM  emacs "^V"
bindkey -rM  emacs "^Q"
bindkey -rM  emacs "^S"
bindkey -rM  emacs "^T"
bindkey -rM  emacs "^Y"
bindkey -rM  emacs "^@"
bindkey -rM  emacs "^_"
bindkey -rM  emacs "^J"
bindkey -rM  emacs "^O"
bindkey -rM  emacs "^R"

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

################################################################
#                 Additional keybinds                          #
################################################################

bindkey "^O" edit-command-line

bindkey " "  zeno-auto-snippet
bindkey "^I" zeno-completion
bindkey "^R" zeno-history-selection
bindkey '^X' zeno-insert-snippet
bindkey '^G' zeno-ghq-cd
