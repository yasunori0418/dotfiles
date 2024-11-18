#!/usr/bin/env bash

# パク…参考にさせてもらいます。
# https://gist.github.com/kuuote/4b2feda31d80fc8266fc562fc7f89c7f
#
declare -r clip_file="/tmp/clip.txt"

echo -n > "${clip_file}"

alacritty \
  --option "window.dimensions.columns=120" \
  --option "window.dimensions.lines=30" \
  --option "window.decorations='FULL'" \
  --class FloatingVim \
  --command nvim "${clip_file}" \
  || exit 1

head -c -1 "${clip_file}" | xsel -bi

dunstify --appname=NVIME "copied in buffer text."
