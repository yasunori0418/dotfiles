#!/usr/bin/env bash

host_type=$(uname -n | awk -F '-' '{print $2}')

yay -Qeqn | rg -v "nvidia|amd|intel" > ./document/pkglist.txt
yay -Qeqm | rg -v "rtl8812au|epsonscan" > ./document/pkglist-foreign.txt

if [[ ${host_type} == 'laptop' ]]; then
  yay -Qeq | rg "amd" > ./document/pkglist-laptop.txt
elif [[ ${host_type} == 'desktop' ]]; then
  yay -Qeq | rg "nvidia|intel|rtl8812au|epsonscan" > ./document/pkglist-desktop.txt
fi
