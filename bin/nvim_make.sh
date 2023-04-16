#!/usr/bin/env bash

repo=${WORKING_DIR}/neovim
bin=/usr/local/bin/nvim
runtime=/usr/local/share/nvim

[[ ! -d ${repo} ]] && git clone https://github.com/neovim/neovim.git ${repo}
cd ${repo}

git pull

if [[ -d ./.deps ]]; then
  if [[ $1 = '-f' && $1 = '--force' ]]; then
    make distclean
  else
    make clean
  fi
fi

make CMAKE_BUILD_TYPE=Release
