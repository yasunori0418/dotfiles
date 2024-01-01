#!/usr/bin/env bash

# latest arch iso downloader

set -e -u -o pipefail

declare -r date_ym1="$(date +'%Y-%m-%d')"
declare -r file_name="archlinux-x86_64.iso"
declare -r iso_url="http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/iso/latest/${file_name}"
declare -r sig_url="${iso_url}.sig"
declare -r download_dir="${HOME}/Downloads/arch_iso_${date_ym1}"

[[ ! -d ${download_dir} ]] && mkdir -p ${download_dir}
cd ${download_dir}

curl -OL ${iso_url} \
     -OL ${sig_url}

if [[ $(command -v pacman-key) ]]; then
  pacman-key -v archlinux-${date_ym1}-x86_64.iso.sig
  exit 0
fi

if [[ $(command -v gpg) ]]; then
  gpg --keyserver-options auto-key-retrieve --verify ${file_name}.sig
  exit 0
fi

echo "Not fonund proof verification command"
exit 1
