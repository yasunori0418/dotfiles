#!/usr/bin/env bash

# パイプの結果を変数に格納するために必須
shopt -s lastpipe

export GHQ_ROOT=${HOME}/src/dotfiles
declare -r dotfiles=${HOME}/dotfiles
declare -r local_bin=${HOME}/.local/bin

declare -Ar modules=(
  # key => {ユーザー名}/{リポジトリ名}
  # value => リンク対象:symlink先
  ["yasunori0418/SKK_Keymap_L2X"]="{keymap,rom-kana,metadata.json}:${dotfiles}/config/libskk/rules/L2X"
  ["rafamadriz/friendly-snippets"]="snippets:${dotfiles}/config/nvim/snippet/vsnip/friendly-snippets"
  ["jluttine/rofi-power-menu"]="rofi-power-menu:${local_bin}/rofi-power-menu"
  ["arcticicestudio/nord-dircolors"]="src/dir_colors:${dotfiles}/home/.dir_colors"
)

ghq get -u --parallel ${!modules[@]}

for module in ${!modules[@]}; do
  # ghq getしてきた物からパスを生成

  # ":"区切りになっているので、1つ目のフィールドをリンク元として変数に格納
  echo ${GHQ_ROOT}/github.com/${module}/${modules[${module}]} \
    | cut -d ":" -f 1 \
    | declare target=$(cat)

  # ":"区切りになっているので、2つ目のフィールドをリンク先として変数に格納
  echo ${modules[${module}]} \
    | cut -d ":" -f 2 \
    | declare link=$(cat)

  ln -svf ${target} ${link}
done
