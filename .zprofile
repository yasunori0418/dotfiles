export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR=/usr/bin/atom
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# fix "xdg-open fork-bomb" export your preferred browser from here
export BROWSER=/usr/bin/google-chrome-stable

# Pyenv enviroment variable.
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# User add enviroment variable.
export PATH=$PATH:$HOME/bin
export XDG_CONFIG_HOME="$HOME/.config"

# My dotfiles enviroment path setting.
export DOTFILES=$HOME/dotfiles

# $MYVIMRC eviroment path setting.
export MYVIMRC=$DOTFILES/.vim/init.vim
