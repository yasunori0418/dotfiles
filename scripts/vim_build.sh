#!/usr/bin/env -S bash

set -euo pipefail

ghq_root=$(ghq root)
readonly ghq_root
declare -r host=github.com
declare -r repo=vim/vim
declare -r install_prefix=${HOME}/.local/dotfiles/vim
declare -r configure_options=(
  --with-features=huge
  --enable-autoservername
  --enable-multibyte
  --enable-terminal
  --enable-fontset
  --enable-gui=gtk3
  --enable-perlinterp
  --enable-python3interp
  --enable-rubyinterp
  --enable-tclinterp
  --enable-luainterp
  --with-luajit
  --enable-fail-if-missing
  --prefix="${install_prefix}"
)

ghq get -u https://${host}/${repo}.git
cd "${ghq_root}/${host}/${repo}/src"

if [[ -d ./.deps ]]; then
  make clean
  git restore .
fi

[[ -d ${install_prefix} ]] && rm -rf "${install_prefix}"

./configure "${configure_options[@]}"

make install
