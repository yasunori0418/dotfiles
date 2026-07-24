#!/usr/bin/env bash

set -euo pipefail

KERNEL_NAME=$(uname -s)
readonly KERNEL_NAME

if [[ ${KERNEL_NAME} != "Linux" && ${KERNEL_NAME} != "Darwin" ]]; then
    echo "unsupported system"
    exit 1
fi

# 実行する rebuild コマンドを配列で組み立てて、末尾で 1 回だけ実行する。
# 従来は `[[ ... ]] && cmd` を並べていたが、最後の `[[ ]]` が false のとき
# その exit code (=1) がスクリプト全体の戻り値になり、反映は成功しているのに
# make が Error 1 で落ちていた。
rebuild_cmd=()

if [[ ${KERNEL_NAME} = "Linux" ]]; then
    rebuild_cmd=(sudo nixos-rebuild switch --accept-flake-config --flake .)
elif command -v darwin-rebuild &>/dev/null; then
    rebuild_cmd=(sudo darwin-rebuild switch --flake .)
else
    rebuild_cmd=(sudo nix run 'nix-darwin/master#darwin-rebuild' -- switch --flake .)
fi

if command -v nom &>/dev/null; then
    sudo -v
    "${rebuild_cmd[@]}" |& nom
else
    "${rebuild_cmd[@]}"
fi
