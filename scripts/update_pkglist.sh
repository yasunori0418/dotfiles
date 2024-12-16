#!/usr/bin/env bash

set -euo pipefail

host_type=$(uname -n | awk -F '-' '{print $2}')

yay -Qeqn | rg -v "nvidia|ollama-cuda" > ./document/pkglist.txt
yay -Qeqm | rg -v "rtl8812au|epsonscan" > ./document/pkglist-foreign.txt

if [[ ${host_type} == 'desktop' ]]; then
    yay -Qeq | rg "nvidia|epsonscan|minecraft|ollama-cuda" > ./document/pkglist-desktop.txt
fi
