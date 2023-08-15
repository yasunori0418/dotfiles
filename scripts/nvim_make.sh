#!/usr/bin/env bash

set -e -u -o pipefail

declare -r repo=$(ghq list -p | rg neovim)
declare -r install_prefix=${HOME}/.local/dotfiles/nvim

ghq get -u https://github.com/neovim/neovim.git
cd ${repo}

if [[ -d ./.deps ]]; then
  if [[ $1 = '-f' || $1 = '--force' ]]; then
    make distclean
  else
    make clean
  fi
fi

rm -rf ${install_prefix}

make \
  CMAKE_INSTALL_PREFIX=${install_prefix} \
  CMAKE_BUILD_TYPE=Release \
  install

if [[ $(command -v nvim) ]]; then
  nvim -V1 -v
  exit 0
else
  echo "Failure install of neovim."
  exit 1
fi
