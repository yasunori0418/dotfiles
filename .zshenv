export EDITOR=/usr/bin/nvim
export TERMINAL=/usr/bin/wezterm
#export BROWSER=/usr/bin/google-chrome-stable
export PATH=$PATH:$HOME/bin
export XDG_CONFIG_HOME=$HOME/.config

# Pyenv enviroment variable.
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# volta environments
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
