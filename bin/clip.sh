#!/usr/bin/env bash

# パク…参考にさせてもらいます。
# https://gist.github.com/kuuote/4b2feda31d80fc8266fc562fc7f89c7f
#
clip_file=/tmp/clip
[[ -f ${clip_file} ]] && rm ${clip_file}
touch ${clip_file}
wezterm start --class Floaterm nvim --listen ~/.cache/nvim/server.pipe ${clip_file} || exit 1
head -c -1 ${clip_file} | xsel -bi
dunstify --appname=nv_IME "copied in buffer text."
