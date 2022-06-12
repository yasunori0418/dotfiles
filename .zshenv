export EDITOR=/usr/bin/nvim
#export BROWSER=/usr/bin/google-chrome-stable
export PATH=$PATH:$HOME/bin
export XDG_CONFIG_HOME=$HOME/.config

# Pyenv enviroment variable.
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
