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
export EDITOR=$(which nvim)
export TERMINAL=/usr/bin/wezterm
export XDG_CONFIG_HOME=${HOME}/.config
export XDG_CACHE_HOME=${HOME}/.cache

# Docker rootless config
export DOCKER_HOST=unix://${XDG_RUNTIME_DIR}/docker.sock

# ssh-agent socket
export SSH_AUTH_SOCK=${XDG_RUNTIME_DIR}/ssh-agent.socket
