#!/usr/bin/env bash

set -e -u -o pipefail

declare -r dotfiles=${HOME}/dotfiles
declare -r modules=${dotfiles}/modules
declare -r bin=${dotfiles}/bin/
declare -r latest_releases=https://api.github.com/repos/jdxcode/rtx/releases/latest
declare -r dl_file=${modules}/rtx.tar.gz
declare -r rtx_bin=${modules}/rtx/bin/rtx

curl -s ${latest_releases} \
  | grep browser_download_url \
  | cut -d ":" -f 2,3 \
  | tr -d \" \
  | grep linux-x64.tar.gz \
  | xargs curl -L > ${dl_file}

cd ${modules}
tar zxvf ${dl_file}
rm ${dl_file}

ln -svf ${rtx_bin} ${bin}
