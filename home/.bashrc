#
# ~/.bashrc
#

# bash options
# https://linuxjm.osdn.jp/html/GNU_bash/man1/bash.1.html
shopt -s autocd
shopt -s cdable_vars
shopt -s cdspell
shopt -s checkjobs
shopt -s checkwinsize         # default
shopt -s cmdhist              # default
shopt -s dirspell
shopt -s direxpand
shopt -s dotglob
shopt -s execfail
shopt -s expand_aliases       # default
shopt -s extglob
shopt -s extquote             # default
shopt -s failglob
shopt -s force_fignore        # default
shopt -s globasciiranges      # default
shopt -s globstar
shopt -s hostcomplete         # default
shopt -s interactive_comments # default
shopt -s nocaseglob
shopt -s nocasematch
shopt -s nullglob
shopt -s progcomp             # default
shopt -s promptvars           # default
shopt -s sourcepath           # default

set -o allexport
set -o braceexpand            # default
set -o emacs                  # default
set -o errexit
set -o hashall                # default
set -o histexpand             # default
set -o history                # default
set -o interactive-comments   # default
set -o monitor                # default
set -o notify
set -o pipefail
set -o physical

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Aliases
# ls
alias ls='ls --color=auto'
alias la='ls -laA'
alias ll='ls -laAG'

# clear
alias c='clear'
alias cc='c &&'

# Prompt string
PS1='[\u@\h \W]\$ '
