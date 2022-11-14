#! /usr/bin/env bash

cd $HOME

git clone --recursive https://github.com/yasunori-kirin0418/dotfiles.git

ln -svf ~/dotfiles/modules/nord-dircolors/src/dir_colors ~/dotfiles/home/.dir_colors
ln -svf ~/dotfiles/modules/SKK_Keymap_L2X ~/dotfiles/config/libskk/rules/SKK_Keymap_L2X
ln -svf ~/dotfiles/modules/friendly-snippets ~/dotfiles/home/.vsnip/friendly-snippets

ln -svf ~/dotfiles/home/.?* ~/
ln -svf ~/dotfiles/bin ~/
ln -svf ~/dotfiles/config/* ~/.config/
