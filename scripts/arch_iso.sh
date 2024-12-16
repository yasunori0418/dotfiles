#!/usr/bin/env bash

# latest arch iso downloader

set -e -u -o pipefail

date_ym1="$(date +'%Y-%m-%d')"
readonly date_ym1
declare -r img_file="archlinux-x86_64.iso"
declare -r iso_url="http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/iso/latest/${img_file}"
declare -r sig_url="${iso_url}.sig"
declare -r download_dir="${HOME}/Downloads/arch_iso_${date_ym1}"

[[ ! -d ${download_dir} ]] && mkdir -p "${download_dir}"
cd "${download_dir}"

curl -OL ${iso_url} \
    -OL ${sig_url}

if [[ $(command -v pacman-key) ]]; then
    pacman-key -v "${img_file}.sig"
    exit 0
fi

if [[ $(command -v gpg) ]]; then
    gpg --keyserver-options auto-key-retrieve --verify "${img_file}.sig"
    exit 0
fi

echo "Not fonund proof verification command"
exit 1
