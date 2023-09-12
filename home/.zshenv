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

# rtx
export PATH=${DOTFILES_DATA}/rtx/bin:${PATH}
export RTX_DATA_DIR=${HOME}/.rtx
export RTX_CACHE_DIR=${RTX_DATA_DIR}/cache
export RTX_CONFIG_FILE=${XDG_CONFIG_HOME}/rtx/config.toml

# Docker rootless config
export DOCKER_HOST=unix://${XDG_RUNTIME_DIR}/docker.sock

# ssh-agent socket
export SSH_AUTH_SOCK=${XDG_RUNTIME_DIR}/ssh-agent.socket

# bat theme
export BAT_THEME=Nord

# ヒストリの一覧を読みやすい形に変更
export HISTTIMEFORMAT="[%Y/%M/%D %H:%M:%S] "

# ヒストリーサイズ設定
export HISTFILE=${HOME}/.zhistory
export HISTSIZE=1000000
export SAVEHIST=1000000

# 補完リストが多いときに尋ねない
export LISTMAX=100

# "|,:"を単語の一部とみなさない
export WORDCHARS="${WORDCHARS}|:"

# ls colors
if [[ $(command -v vivid) ]];then
  export LS_COLORS="$(vivid generate nord)"
else
  eval "$(dircolors ~/.dir_colors)"
fi

# zeno.zsh

# git file preview with color
export ZENO_GIT_CAT="bat --color=always"

# git folder preview with color
export ZENO_GIT_TREE="exa --tree"

# if disable builtin completion
export ZENO_DISABLE_BUILTIN_COMPLETION=1

### extras environment variable ###

# Pyenv enviroment variable.
# Pyenv settings
if [[ -d ${HOME}/.pyenv ]]; then
  export PYENV_ROOT=${HOME}/.pyenv
  export PATH=${PATH}:${PYENV_ROOT}/bin
fi

# if installed binary by rust-cargo
if [[ -d ${HOME}/.cargo/bin ]]; then
  export PATH=${PATH}:${HOME}/.cargo/bin
fi

# themis environment
if [[ -d ${HOME}/.cache/dein/repos/github.com/thinca/vim-themis/bin ]]; then
  export PATH=${PATH}:${HOME}/.cache/dein/repos/github.com/thinca/vim-themis/bin
fi

# go package
if [[ -d ${HOME}/go/bin ]]; then
  export PATH=${PATH}:${HOME}/go/bin
fi
