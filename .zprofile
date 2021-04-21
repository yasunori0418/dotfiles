# Pyenv enviroment variable.
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# User add enviroment variable.
export PATH=$PATH:$HOME/bin
