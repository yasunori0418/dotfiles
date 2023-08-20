# https://zsh.sourceforge.io/Doc/Release/Options.html#Options

## Change Directories
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_SILENT
setopt PUSHD_IGNORE_DUPS

## Zle
unsetopt BEEP
setopt ZLE

# initial setting bindkeys
bindkey -d # Reset bindkeys
bindkey -e # emacs keybind
