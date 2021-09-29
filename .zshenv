export EDITOR=/usr/bin/nvim
export BROWSER=/usr/bin/google-chrome-stable
export PATH=$PATH:$HOME/bin

# Pyenv enviroment variable.
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
