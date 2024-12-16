#!/usr/bin/env bash

set -e -u -o pipefail

ghq_root=$(ghq root)
readonly ghq_root
declare -r host=github.com
declare -r repo=neovim/neovim
declare -r install_prefix=${HOME}/.local/dotfiles/nvim

ghq get -u https://${host}/${repo}.git
cd "${ghq_root}/${host}/${repo}"

if [[ -d ./.deps ]]; then
    make clean
    git restore .
fi

[[ -d ${install_prefix} ]] && rm -rf "${install_prefix}"

make \
    CMAKE_INSTALL_PREFIX="${install_prefix}" \
    CMAKE_BUILD_TYPE=Release \
    BUNDLED_CMAKE_FLAG='-DUSE_BUNDLED_TS_PARSERS=OFF' \
    install

rm -rf "${install_prefix:?}/lib"

if [[ $(command -v nvim) ]]; then
    nvim -V1 -v
    exit 0
else
    echo "Failure install of neovim."
    exit 1
fi
