#!/usr/bin/env bash

set -e -u -o pipefail

declare -r install_prefix=${HOME}/.local/dotfiles
declare -r tag_name=nightly
declare -r dl_file=nvim-linux64.tar.gz
declare -r download_url=https://github.com/neovim/neovim/releases/download/${tag_name}/${dl_file}

curl -Lo "${install_prefix}/${dl_file}" "${download_url}"

cd "${install_prefix}"
tar zxvf "${dl_file}"
rm "${dl_file}"

[[ -d ${install_prefix}/nvim ]] && rm -rf "${install_prefix}/nvim"
mv "${install_prefix}/nvim-linux64" "${install_prefix}/nvim"
rm -rf nvim/lib

echo -e '\n\n\n'

if [[ $(command -v nvim) ]]; then
  nvim -V1 -v
  exit 0
else
  echo "Failure install of neovim."
  exit 1
fi
