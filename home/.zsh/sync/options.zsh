# https://zsh.sourceforge.io/Doc/Release/Options.html#Options
#
################################
#
# skip options
# * Scripts and Functions
# * Shell Emulation
# * Shell State
# * Option Aliases
#
################################
#
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

## Completion
setopt ALWAYS_LAST_PROMPT
unsetopt ALWAYS_TO_END
setopt AUTO_LIST
setopt AUTO_MENU
unsetopt AUTO_NAME_DIRS
setopt AUTO_PARAM_KEYS
setopt AUTO_PARAM_SLASH
setopt AUTO_REMOVE_SLASH
unsetopt BASH_AUTO_LIST
unsetopt COMPLETE_ALIASES
unsetopt COMPLETE_IN_WORD
unsetopt GLOB_COMPLETE
setopt HASH_LIST_ALL
setopt LIST_AMBIGUOUS
setopt LIST_BEEP
unsetopt LIST_PACKED
unsetopt LIST_ROWS_FIRST
setopt LIST_TYPES
unsetopt MENU_COMPLETE
unsetopt REC_EXACT

## Expansion and Globbing
setopt BAD_PATTERN
setopt BARE_GLOB_QUAL
setopt BRACE_CCL
setopt CASE_GLOB
setopt CASE_MATCH
setopt CASE_PATHS
setopt CSH_NULL_GLOB
setopt EQUALS
setopt EXTENDED_GLOB
unsetopt FORCE_FLOAT
setopt GLOB
setopt GLOB_ASSIGN
setopt GLOB_DOTS
setopt GLOB_STAR_SHORT
setopt GLOB_SUBST
setopt HIST_SUBST_PATTERN
unsetopt IGNORE_BRACES
unsetopt IGNORE_CLOSE_BRACES
setopt KSH_GLOB
setopt MAGIC_EQUAL_SUBST
setopt MARK_DIRS
setopt MULTIBYTE
setopt NOMATCH
setopt NULL_GLOB
setopt NUMERIC_GLOB_SORT
unsetopt RC_EXPAND_PARAM
setopt REMATCH_PCRE
unsetopt SH_GLOB
setopt UNSET
unsetopt WARN_CREATE_GLOBAL
unsetopt WARN_NESTED_VAR

## History
setopt APPEND_HISTORY
setopt BANG_HIST
setopt EXTENDED_HISTORY
setopt HIST_ALLOW_CLOBBER
setopt HIST_BEEP
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FCNTL_LOCK
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_LEX_WORDS
setopt HIST_NO_FUNCTIONS
unsetopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_BY_COPY
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt INC_APPEND_HISTORY_TIME
setopt SHARE_HISTORY

## Initialisation
unsetopt ALL_EXPORT
unsetopt GLOBAL_EXPORT
setopt GLOBAL_RCS
setopt RCS

## Input/Output
setopt ALIASES
setopt CLOBBER
unsetopt CLOBBER_EMPTY
setopt CORRECT
setopt CORRECT_ALL
unsetopt DVORAK
setopt FLOW_CONTROL
unsetopt IGNORE_EOF
setopt INTERACTIVE_COMMENTS
setopt HASH_CMDS
setopt HASH_DIRS
unsetopt HASH_EXECUTABLES_ONLY
unsetopt MAIL_WARNING
unsetopt PATH_DIRS
unsetopt PATH_SCRIPT
setopt PRINT_EIGHT_BIT
setopt PRINT_EXIT_VALUE
unsetopt RC_QUOTES
unsetopt RM_STAR_SILENT
unsetopt SHORT_LOOPS
setopt SUN_KEYBOARD_HACK

## Job Control
unsetopt AUTO_CONTINUE
unsetopt AUTO_RESUME
setopt BG_NICE
setopt CHECK_JOBS
setopt CHECK_RUNNING_JOBS
unsetopt HUP
setopt LONG_LIST_JOBS
setopt MONITOR
setopt NOTIFY
setopt POSIX_JOBS

## Prompting
setopt PROMPT_BANG
unsetopt PROMPT_CR # when use p10k, must be unset
unsetopt PROMPT_SP # when use p10k, must be unset
setopt PROMPT_PERCENT
setopt PROMPT_SUBST
setopt TRANSIENT_RPROMPT

## Zle
unsetopt BEEP
setopt COMBINING_CHARS
# unsetopt EMACS # setting by ../defer/bindkey.zsh
unsetopt OVERSTRIKE
# setopt VI # setting by ../defer/bindkey.zsh
setopt ZLE

# initial setting bindkeys
bindkey -d # Reset bindkeys
bindkey -e # emacs keybind
