#!/usr/bin/env bash

set -e -u -o pipefail

declare -r cache=${HOME}/.cache
declare -r bin=${HOME}/.local/bin
declare -r dl_file=${cache}/rtx.tar.gz
declare -r rtx_bin=${cache}/rtx/bin/rtx
declare -r latest_releases=https://api.github.com/repos/jdxcode/rtx/releases/latest

curl -s ${latest_releases} \
  | grep browser_download_url \
  | cut -d ":" -f 2,3 \
  | tr -d \" \
  | grep linux-x64.tar.gz \
  | xargs curl -L > ${dl_file}

cd ${cache}
tar zxvf ${dl_file}
rm ${dl_file}

ln -svf ${rtx_bin} ${bin}
