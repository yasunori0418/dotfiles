#!/usr/bin/env bash

# latest arch iso downloader

date_ym1=`date +'%Y.%m.01'`
file_name="archlinux-${date_ym1}-x86_64.iso"
iso_url="http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/iso/${date_ym1}/${file_name}"
sig_url="${iso_url}.sig"
download_dir=${HOME}/Downloads/arch_iso_${date_ym1}

[[ ! -d ${download_dir} ]] && mkdir -p ${download_dir}
cd ${download_dir}

curl -OL ${iso_url} \
     -OL ${sig_url}

pacman-key -v archlinux-${date_ym1}-x86_64.iso.sig
