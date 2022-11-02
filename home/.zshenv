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
