#!/usr/bin/env bash

set -e -u -o pipefail

dotfiles=${HOME}/dotfiles
readonly dotfiles

modules=${dotfiles}/modules
readonly modules

bin=${dotfiles}/bin/
readonly bin

latest_releases=https://api.github.com/repos/jdxcode/rtx/releases/latest
readonly latest_releases

dl_file=${modules}/rtx.tar.gz
readonly dl_file

rtx_bin=${modules}/rtx/bin/rtx
readonly rtx_bin

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
