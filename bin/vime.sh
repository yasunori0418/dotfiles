#!/usr/bin/env -S bash

# パク…参考にさせてもらいます。
# https://gist.github.com/kuuote/4b2feda31d80fc8266fc562fc7f89c7f
#
declare -r clip_file="/tmp/clip.txt"
declare -r nvim="${HOME}/.local/dotfiles/nvim/bin/nvim"
eval "$(mise hook-env -s zsh)"

[[ -f ${clip_file} ]] && rm ${clip_file}
touch ${clip_file}

wezterm \
  --config initial_rows=30 \
  --config initial_cols=120 \
  --config enable_tab_bar=false \
  start --class FloatingVim \
  ${nvim} --listen ~/.cache/nvim/server.pipe ${clip_file} \
  || exit 1

head -c -1 ${clip_file} | xsel -bi

dunstify --appname=NVIME "copied in buffer text."
