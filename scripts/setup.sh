#!/usr/bin/env bash

set -euo pipefail

export AQUA_GLOBAL_CONFIG="${HOME}/.config/aqua/config.yaml"
export AQUA_PROGRESS_BAR=true
export PATH="${HOME}/.local/share/aquaproj-aqua/bin:${HOME}/.local/dotfiles/nvim/bin:${PATH}"

aqua install --all

sleep 3
mise install --yes

sleep 3
bash "${HOME}/dotfiles/scripts/nvim_night.sh"

sleep 3
nvim

zsh -l
