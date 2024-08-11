#!/usr/bin/env -S bash

set -euo pipefail

ln -snvf ~/dotfiles/home/.??* ~
ln -snvf ~/dotfiles/home/package.json ~
ln -snvf ~/dotfiles/home/bun.lockb ~
ln -snvf ~/dotfiles/bin ~
ln -snvf ~/dotfiles/config/* ~/.config

if [[ -d /nix && $(command -v devbox) ]]; then
  ln -svf ~/dotfiles/local/share/devbox/global/default/* ~/.local/share/devbox/global/default/
fi

if [[ $(uname -s) = 'Darwin' ]]; then
  ln -svf ~/dotfiles/Library/ApplicationSupport/* "$HOME/Library/Application Support"
fi
