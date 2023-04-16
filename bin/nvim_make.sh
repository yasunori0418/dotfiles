#!/usr/bin/env bash

repo=${WORKING_DIR}/neovim
bin=/usr/local/bin/nvim
runtime=/usr/local/share/nvim

[[ ! -d ${repo} ]] && git clone git@github.com:neovim/neovim.git ${repo}
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

echo
read -sp "Password: " pass
echo

uninstall_cmd="sudo rm -rf ${bin} ${runtime}"
echo 'Remove binary and runtime.'
expect -c "
  spawn ${uninstall_cmd}
  expect \"sudo\"
  send \"${pass}\n\"
  exit 0
"

install_cmd="sudo make install"
echo 'Install Neovim'
expect -c "
  spawn ${install_cmd}
  exit 0
"
