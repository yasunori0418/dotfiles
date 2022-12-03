#!/usr/bin/env bash

# Variables
local_bin=${HOME}/.local/bin
skktools_dir=${HOME}/.cache/skktools
skktools=('skkdic-expr' 'skkdic-expr2' 'skkdic-sort' 'skkdic-count')

install() {
  cd ${HOME}/.cache
  git clone https://github.com/skk-dev/skktools.git

  cd skktools
  ./configure
  make

  # Expand skktools in .local/bin
  for tool in ${skktools[@]}; do
    cp ${skktools_dir}/${tool} ${local_bin}/${tool}
    echo "Installed ${local_bin}/${tool}"
  done
}

uninstall() {
  # Remove skktools in .local/bin
  for tool in ${skktools[@]}; do
    rm ${local_bin}/${tool}
    echo "Uninstalled ${local_bin}/${tool}"
  done
}

if [[ -n $1 ]]; then
  answer=$1
else
  echo 'Install or Uninstall skktools?'
  read -p "[Install|uninstall] :>" answer
fi

case $answer in
  "install" )
    install
    ;;
  "uninstall" )
    uninstall
    ;;
esac

# vim:ft=bash
