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

export DOTFILES_DATA=${HOME}/.local/dotfiles
export DOTFILES=${HOME}/dotfiles

# User local tools management directory.
export PATH=${HOME}/.local/bin:${PATH}
export PATH=${HOME}/bin:${PATH}

export PATH=${DOTFILES_DATA}/nvim/bin:${PATH}
export EDITOR=${DOTFILES_DATA}/nvim/bin/nvim
export TERMINAL=/usr/bin/wezterm
export XDG_CONFIG_HOME=${HOME}/.config
export XDG_CACHE_HOME=${HOME}/.cache

# rtx
export PATH=${DOTFILES_DATA}/rtx/bin:${PATH}
export RTX_DATA_DIR=${HOME}/.rtx
export RTX_CACHE_DIR=${RTX_DATA_DIR}/cache
export RTX_CONFIG_FILE=${XDG_CONFIG_HOME}/rtx/config.toml
eval "$(rtx activate zsh)"

# Docker rootless config
export DOCKER_HOST=unix://${XDG_RUNTIME_DIR}/docker.sock

# ssh-agent socket
export SSH_AUTH_SOCK=${XDG_RUNTIME_DIR}/ssh-agent.socket

# bat theme
export BAT_THEME=Nord

# ls colors
if [[ $(command -v vivid) ]];then
  export LS_COLORS="$(vivid generate nord)"
else
  eval "$(dircolors ~/.dir_colors)"
fi

### extras environment variable ###

# Pyenv enviroment variable.
# Pyenv settings
if [[ -d ${HOME}/.pyenv ]]; then
  export PYENV_ROOT=${HOME}/.pyenv
  export PATH=${PATH}:${PYENV_ROOT}/bin
  eval "$(pyenv init -)"
fi

# if installed binary by rust-cargo
cargo_bin=${HOME}/.cargo/bin
if [[ -d ${cargo_bin} ]]; then
  export PATH=${PATH}:${cargo_bin}
fi

# themis environment
themis_path=${HOME}/.cache/dein/repos/github.com/thinca/vim-themis/bin
if [[ -d ${themis_path} ]]; then
  export PATH=${PATH}:${themis_path}
fi

# go package
go_bin=${HOME}/go/bin
if [[ -d ${go_bin} ]]; then
  export PATH=${PATH}:${go_bin}
fi
