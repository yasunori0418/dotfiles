#!/usr/bin/env bash

repo=${WORKING_DIR}/neovim
bin=/usr/local/bin/nvim
runtime=/usr/local/share/nvim

[[ ! -d ${repo} ]] && git clone git@github.com:neovim/neovim.git ${repo}
cd ${repo}

git pull

if [[ -d ./.deps ]]; then
  if [[ $1 = "-f" ]]; then
    make distclean
  elif [[ $1 = "-c" ]]; then
    make clean
  fi
fi

make CMAKE_BUILD_TYPE=Release

echo
read -sp "Password: " pass
echo

[[ $(command -v nvim) ]] && uninstall_cmd="sudo rm -rf ${bin} ${runtime}"
install_cmd="sudo make install"

if [[ -v ${uninstall_cmd} ]]; then
  echo "Install after uninstall of Neovim"
  cmd="${uninstall_cmd}; ${install_cmd}"
else
  echo "Install of Neovim"
  cmd="${install_cmd}"
fi

expect -c "
  spawn ${cmd}
  expect \"sudo\"
  send \"${pass}\n\"
  exit 0
"

which nvim

# vim:ft=bash
