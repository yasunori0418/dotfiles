#!/usr/bin/env bash

# パイプの結果を変数に格納するために必須
shopt -s lastpipe
set -e -u -o pipefail

declare -r dotfiles=${HOME}/dotfiles
declare -r local_bin=${HOME}/.local/bin

declare -Ar modules=(
  # key => {ユーザー名}/{リポジトリ名}
  # value => リンク対象:symlink先
  ["yasunori0418/SKK_Keymap_L2X"]=":${dotfiles}/config/libskk/rules/L2X"
  ["rafamadriz/friendly-snippets"]="snippets:${dotfiles}/config/nvim/snippet/vsnip/friendly-snippets"
  ["jluttine/rofi-power-menu"]="rofi-power-menu:${local_bin}/rofi-power-menu"
  ["arcticicestudio/nord-dircolors"]="src/dir_colors:${dotfiles}/home/.dir_colors"
)

declare -r cache=${HOME}/.cache/dotfiles/github.com

for module in ${!modules[@]}; do
  git clone https://github.com/${modules[${module}]}.git ${cache}/${modules[${module}]}

  # ghq getしてきた物からパスを生成
  echo ${cache}/${modules[${module}]} \
    | awk -F ':' '{print $1,$2}' \
    | declare targets=$(cat)

  ln -svf ${targets}
done
