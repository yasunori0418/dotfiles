#!/usr/bin/env bash

set -euo pipefail

mkdir -vp "${HOME}/.local/bin"
mkdir -vp "${HOME}/.local/dotfiles"
mkdir -vp "${HOME}/.local/runtime"
mkdir -vp "${HOME}/.config"
mkdir -vp "${HOME}/.cache"

# aqua install
curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v3.0.1/aqua-installer | bash

cd "${HOME}/dotfiles"

"${HOME}/dotfiles/scripts/expand_symlink.sh"

# shellcheck disable=SC1091
source "${HOME}/dotfiles/home/.zshenv"
aqua install --all

sleep 3
mise install --yes

sleep 3
"${HOME}/dotfiles/scripts/nvim_night.sh"

zsh
