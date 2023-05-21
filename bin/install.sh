#!/usr/bin/env bash

echo '     _       _    __ _ _           '
echo '  __| | ___ | |_ / _(_) | ___  ___ '
echo ' / _` |/ _ \| __| |_| | |/ _ \/ __|'
echo '| (_| | (_) | |_|  _| | |  __/\__ \'
echo ' \__,_|\___/ \__|_| |_|_|\___||___/'

echo '  _            '
echo ' | |__  _   _  '
echo ' | |_ \| | | | '
echo ' | |_) | |_| | '
echo ' |_.__/ \__, | '
echo '        |___/  '

echo '                                        _ '
echo ' _   _  __ _ ___ _   _ _ __   ___  _ __(_)'
echo '| | | |/ _` / __| | | | |_ \ / _ \| |__| |'
echo '| |_| | (_| \__ \ |_| | | | | (_) | |  | |'
echo ' \__, |\__,_|___/\__,_|_| |_|\___/|_|  |_|'
echo ' |___/                                    '

echo -e "\n\n\n\n\n\n\n\n\n\n"

cd $HOME

git clone --recursive https://github.com/yasunori0418/dotfiles.git

ln -svf ~/dotfiles/modules/nord-dircolors/src/dir_colors ~/dotfiles/home/.dir_colors
bash ~/dotfiles/modules/SKK_Keymap_L2X/install.sh
ln -svf ~/dotfiles/modules/friendly-snippets ~/dotfiles/home/.vsnip/friendly-snippets

ln -svf ~/dotfiles/home/.?* ~/
ln -svf ~/dotfiles/bin ~/
ln -svf ~/dotfiles/config/* ~/.config/

nvim -c q!
