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

# tput colors {{{
BG_BLACK="$(tput setab 0)"
BG_RED="$(tput setab 1)"
BG_GREEN="$(tput setab 2)"
BG_YELLOW="$(tput setab 3)"
BG_BLUE="$(tput setab 4)"
BG_MAGENTA="$(tput setab 5)"
BG_CYAN="$(tput setab 6)"
BG_WHITE="$(tput setab 7)"

FG_BLACK="$(tput setaf 0)"
FG_RED="$(tput setaf 1)"
FG_GREEN="$(tput setaf 2)"
FG_YELLOW="$(tput setaf 3)"
FG_BLUE="$(tput setaf 4)"
FG_MAGENTA="$(tput setaf 5)"
FG_CYAN="$(tput setaf 6)"
FG_WHITE="$(tput setaf 7)"

RESET="$(tput sgr0)"
BOLD="$(tput bold)"
INVIS="$(tput invis)"
# }}}

exitstatus()
{
  if [[ $? == 0 ]]; then
    echo ${FG_YELLOW}'(`·ω´·)'${RESET}
  else
    echo ${FG_WHITE}${BG_RED}'(´·ω·`)'${RESET}
  fi
}

right_prompt() {
  local user_name="${FG_RED}`whoami`${RESET}"
  local host_name="${FG_RED}`uname -n`${RESET}"
  local time="${FG_MAGENTA}`date +"%Y-%m-%d_%T"`${RESET}"
  local prompt_strings="${user_name}@${host_name}_${time}"
  printf "%*s" $COLUMNS $prompt_strings
}

left_prompt() {
  local current_dir=${FG_BLUE}${BOLD}`pwd | sed -e "s|$HOME|~|";`${RESET}
  local prompt_strings=${current_dir}
  printf $prompt_strings
}

# Prompt string
#PS1='\n\[$(tput sc; right_prompt; tput rc; tput setaf 4; tput bold)\]\w\[$(tput sgr0; tput setaf 2)\]$(__git_ps1 " << %s >>")\n\[$(tput setaf 7)\]\$ '
PS1='\n\[`tput sc; right_prompt; tput rc; left_prompt`\]${FG_GREEN}$(__git_ps1 " << %s >>")\n${RESET}\$$(exitstatus)>'

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
alias ls='ls --color=always -F'
alias la='ls -laA'
alias lal='ls -laA | less'

# clear
alias c='clear'
alias cc='c &&'

# cd
function custom_cd() {
  \cd $@ ; cc la
}

alias cd=custom_cd
