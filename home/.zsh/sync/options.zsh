# https://zsh.sourceforge.io/Doc/Release/Options.html#Options
# https://vorfee.hatenablog.jp/entry/2015/03/12/182937

## Change Directories
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_SILENT
setopt PUSHD_IGNORE_DUPS

## Completion
setopt ALWAYS_LAST_PROMPT
setopt AUTO_LIST
setopt AUTO_MENU
setopt AUTO_PARAM_KEYS
setopt AUTO_PARAM_SLASH
setopt AUTO_REMOVE_SLASH
setopt HASH_LIST_ALL
setopt LIST_AMBIGUOUS
unsetopt LIST_BEEP
setopt LIST_TYPES

## Zle
unsetopt BEEP
setopt ZLE

# initial setting bindkeys
bindkey -d # Reset bindkeys
bindkey -e # emacs keybind
