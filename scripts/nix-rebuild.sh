#!/usr/bin/env bash

set -euo pipefail

KERNEL_NAME=$(uname -s)
readonly KERNEL_NAME

if [[ ${KERNEL_NAME} != "Linux" && ${KERNEL_NAME} != "Darwin" ]]; then
    echo "unsupported system"
    exit 1
fi

[[ ${KERNEL_NAME} = "Linux" ]] && sudo nixos-rebuild switch --accept-flake-config --flake .

[[ ${KERNEL_NAME} = "Darwin" && $(command -v darwin-rebuild) ]] && sudo darwin-rebuild switch --flake .
[[ ${KERNEL_NAME} = "Darwin" && ! $(command -v darwin-rebuild) ]] && sudo nix run 'nix-darwin/master#darwin-rebuild' -- switch --flake .
