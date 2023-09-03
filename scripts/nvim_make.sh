#!/usr/bin/env bash

set -e -u -o pipefail

declare -r ghq_root=$(ghq root)
declare -r host=github.com
declare -r repo=neovim/neovim
declare -r install_prefix=${HOME}/.local/dotfiles/nvim

ghq get -u https://${host}/${repo}.git
cd ${ghq_root}/${host}/${repo}

if [[ -d ./.deps ]]; then
  make clean
fi

[[ -d ${install_prefix} ]] && rm -rf ${install_prefix}

if [[ ${UID} == 0 ]]; then
  make CMAKE_BUILD_TYPE=Release
else
  make CMAKE_INSTALL_PREFIX=${install_prefix} CMAKE_BUILD_TYPE=Release
fi
make install

rm -rf ${install_prefix}/lib

if [[ $(command -v nvim) ]]; then
  nvim -V1 -v
  exit 0
else
  echo "Failure install of neovim."
  exit 1
fi
