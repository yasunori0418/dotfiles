#! /usr/bin/env zsh

# When logined startx with auto start 
if [[ -z ${DISPLAY} && ${XDG_VTNR} -eq 1 ]]; then
  exec startx
fi
