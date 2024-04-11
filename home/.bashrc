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

# shellcheck source=$HOME/.bash
source ~/.bash/git-completion.bash
# shellcheck source=$HOME/.bash
source ~/.bash/git-prompt.sh

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUPSTREAM=auto
export GIT_PS1_STATESEPARATOR=' | '
export GIT_PS1_SHOWCONFLICTSTATE=yes
export GIT_PS1_DESCRIBE_STYLE=default
# }}}

# tput colors {{{
# BG_BLACK=$(tput setab 0)
BG_RED=$(tput setab 1)
# BG_GREEN=$(tput setab 2)
# BG_YELLOW=$(tput setab 3)
# BG_BLUE=$(tput setab 4)
# BG_MAGENTA=$(tput setab 5)
# BG_CYAN=$(tput setab 6)
# BG_WHITE=$(tput setab 7)

# FG_BLACK=$(tput setaf 0)
FG_RED=$(tput setaf 1)
FG_GREEN=$(tput setaf 2)
# FG_YELLOW=$(tput setaf 3)
FG_BLUE=$(tput setaf 4)
FG_MAGENTA=$(tput setaf 5)
# FG_CYAN=$(tput setaf 6)
FG_WHITE=$(tput setaf 7)

RESET=$(tput sgr0)
BOLD=$(tput bold)
# INVIS=$(tput invis)
ITALIC=$(tput sitm)
# }}}

# archlinux.wiki Bash/プロンプトのカスタマイズ
__right_prompt() {
  local user_name host_name time
  user_name="${FG_RED}$(whoami)${RESET}"
  host_name="${FG_RED}$(uname -n)${RESET}"
  time="${FG_MAGENTA}$(date +"%Y-%m-%d_%T")${RESET}"
  local prompt_strings="${user_name}@${host_name}"
  printf "%*s %s" ${COLUMNS} "${prompt_strings}" "${time}"
}

__left_prompt() {
  local current_dir
  current_dir=${FG_BLUE}${BOLD}$(pwd | sed -e "s|$HOME|~|";)${RESET}
  printf "%s" "${current_dir}"
}

PROMPT_COMMAND=__prompt_cmd
__prompt_cmd() {
  local git_branch status
  status=$?
  git_branch=${FG_GREEN}$(__git_ps1 ' << %s >>')${RESET}

  # https://www.ryotosaito.com/blog/?p=455
  local -A err_code=(
    [1]='error'     [2]='builtin error' [126]='not executable'  [127]='command not found'
    [128]='SIGHUP'  [129]='SIGINT'      [130]='SIGQUIT'         [131]='SIGILL'
    [132]='SIGTRAP' [133]='SIGABRT'     [134]='SIGEMT'          [135]='SIGFPE'
    [136]='SIGKILL' [137]='SIGBUS'      [138]='SIGSEGV'         [139]='SIGSYS'
    [140]='SIGPIPE' [141]='SIGALRM'     [142]='SIGTERM'         [143]='SIGURG'
    [144]='SIGSTOP' [145]='SIGTSTP'     [146]='SIGCONT'         [147]='SIGCHLD'
    [148]='SIGTTIN' [149]='SIGTTOU'     [150]='SIGIO'           [151]='SIGXCPU'
    [152]='SIGXFSZ' [153]='SIGVTALRM'   [154]='SIGPROF'         [155]='SIGWINCH' 
    [156]='SIGINFO' [157]='SIGUSR1'     [158]='SIGUSR2'
  )

  PS1="\n\[$(tput sc; __right_prompt; tput rc; __left_prompt)\]${git_branch}\n"

  if [[ $status -ne 0 ]]; then
    PS1+=" ${FG_WHITE}${BG_RED}${ITALIC}|${status}:${err_code[${status}]}|${RESET}"
  fi

  PS1+=' \$>'
}

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
  \cd "$@" || return
  cc la
}

alias cd=custom_cd
