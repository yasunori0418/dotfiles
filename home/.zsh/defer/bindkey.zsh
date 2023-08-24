## Remove keybinds of default.
bindkey -rpM emacs "^X"
bindkey -rpM emacs "^["
bindkey -r "^G"
bindkey -r "^?"
bindkey -r "^V"
bindkey -r "^Q"
bindkey -r "^S"
bindkey -r "^T"
bindkey -r "^Y"
bindkey -r "^@"
bindkey -r "^_"
bindkey -r "^J"
bindkey -r "^O"

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
# bindkey "^R" history-incremental-search-backward
# bindkey "^U" kill-whole-line
# bindkey "^W" backward-kill-word

################################################################
#                 Additional keybinds                          #
################################################################

bindkey "^O" edit-command-line
