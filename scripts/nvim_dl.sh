#!/usr/bin/env bash

set -euo pipefail


os_name () {
  if [[ $(uname -s) = "Linux" ]]; then
    echo "linux64"
  fi
  if [[ $(uname -s) = "Darwin" ]]; then
    echo "macos-$(uname -m)"
  fi
}

declare -r install_prefix="${HOME}/.local/dotfiles"
declare -r tag_name="${1:-stable}" # nightly | stable
file_name="nvim-$(os_name)"
readonly file_name
declare -r archive_file_name="${file_name}.tar.gz"
declare -r download_base_url="https://github.com/neovim/neovim/releases/download"
declare -r download_bin_url="${download_base_url}/${tag_name}/${archive_file_name}"
declare -r download_sha256_url="${download_base_url}/${tag_name}/${archive_file_name}.sha256sum"

curl -Lo "${install_prefix}/${archive_file_name}" "${download_bin_url}"
curl -Lo "${install_prefix}/${archive_file_name}.sha256sum" "${download_sha256_url}"

# downloadしたディレクトリで作業
cd "${install_prefix}"
sha256sum -c "${archive_file_name}.sha256sum"
[[ $? -eq 1 ]] && exit 1
tar zxf "${archive_file_name}"
rm "${archive_file_name}" "${archive_file_name}.sha256sum"

# 前のバージョンの物と入れ替え
[[ -d ${install_prefix}/nvim ]] && rm -rf "${install_prefix}/nvim"
mv "${install_prefix}/${file_name}" "${install_prefix}/nvim"
rm -rf nvim/lib # delete treesitter parsers

if [[ $(command -v nvim) ]]; then
  nvim -V1 -v
  ls -la "${install_prefix}"
  exit 0
else
  echo "Failure install of neovim."
  exit 1
fi
