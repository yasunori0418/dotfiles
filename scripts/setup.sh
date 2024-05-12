#!/usr/bin/env bash

set -euo pipefail

cd "${HOME}/dotfiles"

# shellcheck disable=SC1091
source "${HOME}/dotfiles/home/.zshenv"
aqua install --only-link --all
mise install --yes

make nvim-night

zsh
