#!/usr/bin/env zsh
#
# ~/.zshenv
#

export LESS="\
  --ignore-case \
  --quit-if-one-screen \
  --no-init \
  --LONG-PROMPT \
  --RAW-CONTROL-CHARS \
  --hilite-search \
  --HILITE-UNREAD \
  --window=-4 \
  --tabs=4"

[[ -n $(toe -a | cut -f1 | grep xterm-256color) ]] && export TERM=xterm-256color

if [[ $(command -v vivid) ]];then
  export LS_COLORS="$(vivid generate nord)"
else
  eval "$(dircolors ~/.dir_colors)"
fi

export EDITOR=/usr/bin/nvim
export TERMINAL=/usr/bin/wezterm
export XDG_CONFIG_HOME=${HOME}/.config
export XDG_CACHE_HOME=${HOME}/.cache

[[ ! -d ${HOME}/dev ]] && mkdir ${HOME}/dev
export WORKING_DIR=${HOME}/dev

# User local tools management directory.
[[ ! -d ${HOME}/.local/bin ]] && mkdir -p ${HOME}/.local/bin
export PATH=${PATH}:${HOME}/.local/bin:${HOME}/bin

# rtx
if [[ $(command -v rtx) ]]; then
  export RTX_DATA_DIR=$HOME/.rtx
  export RTX_CACHE_DIR=$RTX_DATA_DIR/cache
  export RTX_CONFIG_FILE=$XDG_CONFIG_HOME/rtx/config.toml
  eval "$(rtx activate zsh)"
fi

# Pyenv enviroment variable.
# Pyenv settings
if [[ -d ${HOME}/.pyenv ]]; then
  export PYENV_ROOT=${HOME}/.pyenv
  export PATH=${PATH}:${PYENV_ROOT}/bin
  eval "$(pyenv init -)"
fi

# volta environments
if [[ -d ${HOME}/.volta ]]; then
  export VOLTA_HOME=${HOME}/.volta
  export PATH=${PATH}:${VOLTA_HOME}/bin
fi

# deno environmet variable.
if [[ -d ${HOME}/.deno ]]; then
  export PATH=${PATH}:${HOME}/.deno/bin
fi

# if installed binary by rust-cargo
if [[ -d ${HOME}/.cargo/bin ]]; then
  export PATH=${PATH}:${HOME}/.cargo/bin
fi

# themis environment
themis_path=${HOME}/.cache/dein/repos/github.com/thinca/vim-themis/bin
if [[ -d ${themis_path} ]]; then
  export PATH=${PATH}:${themis_path}
fi

# Guix package manager
#export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"
#export GUIX_PROFILE="$HOME/.guix-profile"
#source $GUIX_PROFILE/etc/profile
#export PATH="$GUIX_PROFILE/bin:$PATH"

# Docker rootless config
export DOCKER_HOST=unix://${XDG_RUNTIME_DIR}/docker.sock

# ssh-agent socket
export SSH_AUTH_SOCK=${XDG_RUNTIME_DIR}/ssh-agent.socket

# bat theme
[[ $(which bat) ]] && export BAT_THEME=Nord

# Joplin
#joplin_path=${HOME}/.joplin
#if [[ ! -d ${joplin_path} ]]; then
#  curl -Ss https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
#fi
#export PATH="${PATH}:${joplin_path}"

# go package
go_bin=${HOME}/go/bin
if [[ -d ${go_bin} ]]; then
  export PATH=${PATH}:${go_bin}
fi
