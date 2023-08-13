#!/usr/bin/env bash

repo=$(ghq list -p | rg neovim)
readonly repo

install_prefix=${HOME}/.local/nvim
readonly install_prefix

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
