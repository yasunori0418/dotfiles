#!/usr/bin/env bash

set -e -u -o pipefail

declare -r install_prefix=${HOME}/.local
declare -r dl_file=${install_prefix}/rtx.tar.gz
declare -r latest_releases=https://api.github.com/repos/jdxcode/rtx/releases/latest

curl -s ${latest_releases} \
  | grep browser_download_url \
  | cut -d ":" -f 2,3 \
  | tr -d \" \
  | grep linux-x64.tar.gz \
  | xargs curl -L > ${dl_file}

cd ${install_prefix}
tar zxvf ${dl_file}
rm ${dl_file}
