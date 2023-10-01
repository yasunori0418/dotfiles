#!/usr/bin/env bash

set -e -u -o pipefail
eval "$(rtx hook-env -s zsh)"

declare FloatingVim=$( \
  i3-msg -t get_tree \
  | jq -c '.. | .floating_nodes? | arrays[] | select(.app_id=="FloatingVim")' \
)

if [[ -z ${FloatingVim} ]]; then
  wezterm \
  --config initial_rows=10 \
  --config initial_cols=70 \
  --config enable_tab_bar=false \
  start --class FloatingVim ${HOME}/.local/dotfiles/nvim/bin/nvim
else
  if [[ $(echo $FloatingVim | jq .focused) = 'true' ]]; then
    i3-msg "move window to scratchpad"
  else
    i3-msg "[app_id=\"FloatingVim\"] focus"
  fi
fi
