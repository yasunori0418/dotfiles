# https://zsh.sourceforge.io/Doc/Release/Options.html#Options
# https://vorfee.hatenablog.jp/entry/2015/03/12/182937

## Change Directories
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_SILENT
setopt PUSHD_IGNORE_DUPS

## Completion
# defaults
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

setopt LIST_PACKED
setopt MENU_COMPLETE

## Expantion and Globbing
# defaults
setopt CASE_GLOB
setopt CASE_MATCH
setopt GLOB
setopt MULTIBYTE

setopt EXTENDED_GLOB

## History
# defaults
setopt APPEND_HISTORY
unsetopt HIST_BEEP
setopt HIST_SAVE_BY_COPY

setopt INC_APPEND_HISTORY
setopt HIST_REDUCE_BLANKS
setopt HIST_NO_STORE
setopt HIST_NO_FUNCTIONS
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS

## Job Control
setopt LONG_LIST_JOBS
setopt CHECK_JOBS
setopt AUTO_RESUME

## Zle
unsetopt BEEP
setopt ZLE

# initial setting bindkeys
bindkey -d # Reset bindkeys
bindkey -e # emacs keybind
