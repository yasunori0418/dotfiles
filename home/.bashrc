#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Plugin script directory
[[ ! -d ~/.bash ]] && mkdir ~/.bash

# Show git status at prompt. {{{
[[ ! -f ~/.bash/git-completion.bash ]] && curl -o ~/.bash/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
[[ ! -f ~/.bash/git-prompt.sh ]] && curl -o ~/.bash/git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

source ~/.bash/git-completion.bash
source ~/.bash/git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto
GIT_PS1_STATESEPARATOR=' | '
GIT_PS1_SHOWCONFLICTSTATE=yes
GIT_PS1_DESCRIBE_STYLE=default
# }}}

# https://wiki.archlinux.jp/index.php/Bash/%E3%83%97%E3%83%AD%E3%83%B3%E3%83%97%E3%83%88%E3%81%AE%E3%82%AB%E3%82%B9%E3%82%BF%E3%83%9E%E3%82%A4%E3%82%BA#.E3.83.86.E3.82.AD.E3.82.B9.E3.83.88.E3.82.92.E5.8F.B3.E3.81.AB.E6.95.B4.E5.88.97
right_prompt() {
  local prompt_strings=`whoami`@`uname -n`
  printf "%*s" $(($COLUMNS - 2)) $prompt_strings
}
# Prompt string
PS1='\[$(tput sc; tput setaf 6; right_prompt; tput rc; tput setaf 4; tput bold)\]\w\[$(tput sgr0; tput setaf 2)\]$(__git_ps1 " << %s >>")\n\[$(tput setaf 7)\]\$ '

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
#set -o errexit
set -o hashall                # default
set -o histexpand             # default
set -o history                # default
set -o interactive-comments   # default
set -o monitor                # default
set -o notify
set -o pipefail
set -o physical

## Aliases
# ls
alias ls='ls --color=always'
alias la='ls -laA'
alias ll='ls -laAG'
alias lal='ls -laA | less -R'

# clear
alias c='clear'
alias cc='c &&'
