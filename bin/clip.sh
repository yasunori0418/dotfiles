#!/usr/bin/env bash

# パク…参考にさせてもらいます。
# https://gist.github.com/kuuote/4b2feda31d80fc8266fc562fc7f89c7f
#
tmp_file=/tmp/clip
touch ${tmp_file}
wezterm start --class Floaterm nvim --listen ~/.cache/nvim/server.pipe ${tmp_file} || exit 1
head -c -1 ${tmp_file} | xsel -bi
dunstify --appname=nvim "copied"
