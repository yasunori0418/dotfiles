#!/usr/bin/env bash

set -euo pipefail

KERNEL_NAME=$(uname -s)
readonly KERNEL_NAME

if [[ ${KERNEL_NAME} != "Linux" && ${KERNEL_NAME} != "Darwin" ]]; then
    echo "unsupported system"
    exit 1
fi

[[ ${KERNEL_NAME} = "Linux" ]] && sudo nixos-rebuild switch --flake .
[[ ${KERNEL_NAME} = "Darwin" ]] && nix run 'nix-darwin/master#darwin-rebuild' -- switch --flake .
