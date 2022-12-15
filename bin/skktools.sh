#!/usr/bin/env bash

# Variables
local_bin=${HOME}/.local/bin
skktools_dir=${HOME}/.cache/skktools
skktools=('skkdic-expr' 'skkdic-expr2' 'skkdic-sort' 'skkdic-count')

install() {
  git clone https://github.com/skk-dev/skktools.git ${skktools_dir}

  cd ${skktools_dir}
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
  read -p "[Install|uninstall|cancel] :" answer
fi

case $answer in
  "" | "install" )
    install
    ;;
  "uninstall" )
    uninstall
    ;;
  "cancel" )
    echo 'abort script.'
    exit 1
    ;;
esac

# vim:ft=bash
