#!/usr/bin/env bash

neovim_repo=/home/yasunori/dev/neovim

if [[ ${EUID} -ne 0 ]]; then
  echo -e 'Parmission denied.\nPlease run as root.'
  exit 1
fi

neovim_bin=/usr/local/bin/nvim
neovim_runtime=/usr/local/share/nvim

if [[ -f ${neovim_bin} ]]; then
  rm -rf ${neovim_bin} ${neovim_runtime}
fi

cd ${neovim_repo}

make install

chown -Rc yasunori:yasunori ${neovim_repo}

if [[ `command -v nvim` ]]; then
  nvim --version
  exit 0
else
  echo "Failure install of neovim."
  exit 1
fi
