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

git clone https://github.com/yasunori0418/SKK_Keymap_L2X.git modules/SKK_Keymap_L2X
git clone https://github.com/rafamadriz/friendly-snippets.git modules/friendly-snippets
git clone https://github.com/jluttine/rofi-power-menu.git modules/rofi-power-menu
git clone https://github.com/arcticicestudio/nord-dircolors.git modules/nord-dircolors

ln -svf ~/dotfiles/modules/SKK_Keymap_L2X ~/dotfiles/config/libskk/rules/L2X
ln -svf ~/dotfiles/modules/nord-dircolors/src/dir_colors ~/dotfiles/home/.dir_colors
ln -svf ~/dotfiles/modules/friendly-snippets ~/dotfiles/config/nvim/snippet/vsnip/friendly-snippets
ln -svf ~/dotfiles/modules/rofi-power-menu/rofi-power-menu ~/dotfiles/bin/rofi-power-menu

ln -svf ~/dotfiles/home/.?* ~/
ln -svf ~/dotfiles/bin ~/
ln -svf ~/dotfiles/config/* ~/.config/

nvim -c q!
