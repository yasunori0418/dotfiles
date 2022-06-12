export EDITOR=/usr/bin/nvim
#export BROWSER=/usr/bin/google-chrome-stable
export PATH=$PATH:$HOME/bin
export XG_CONFIG_HOME=$HOME/.config

# Pyenv enviroment variable.
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
