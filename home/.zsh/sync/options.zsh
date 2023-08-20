# https://zsh.sourceforge.io/Doc/Release/Options.html#Options

## Change Directories
setopt AUTO_CD
setopt AUTO_PUSHD
unsetopt CDABLE_VARS
setopt CHASE_DOTS
setopt CHASE_LINKS
unsetopt POSIX_CD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS
setopt PUSHD_SILENT

## Zle
unsetopt BEEP
setopt COMBINING_CHARS
unsetopt OVERSTRIKE
setopt ZLE

# initial setting bindkeys
bindkey -d # Reset bindkeys
bindkey -e # emacs keybind
