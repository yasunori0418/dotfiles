#! /usr/bin/env zsh
#
# ~/.zshenv
#

export LESS="--ignore-case \
  --quit-if-one-screen \
  --no-init \
  --LONG-PROMPT \
  --RAW-CONTROL-CHARS \
  --hilite-search \
  --HILITE-UNREAD \
  --window=-4 \
  --tabs=4"

[[ -n $(toe -a | cut -f1 | grep 'xterm-256color') ]] && export TERM='xterm-256color'

if [[ $(command -v vivid) ]];then
  export LS_COLORS=`vivid generate nord`
else
  eval `dircolors ~/.dir_colors`
fi

export EDITOR=/usr/bin/nvim
export TERMINAL=/usr/bin/wezterm
#export BROWSER=/usr/bin/google-chrome-stable
export PATH=$PATH:$HOME/bin
export XDG_CONFIG_HOME=$HOME/.config

# Pyenv enviroment variable.
# Pyenv settings
if [[ -d $HOME/.pyenv ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# volta environments
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Guix package manager
#export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"
#export GUIX_PROFILE="$HOME/.guix-profile"
#source $GUIX_PROFILE/etc/profile
#export PATH="$GUIX_PROFILE/bin:$PATH"

# Docker rootless config
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

# ssh-agent socket
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

# bat theme
[[ $(command -v bat) ]] && export BAT_THEME=Nord
