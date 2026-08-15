#!/usr/bin/env bash

# herdr セッションを fzf で選んで stop / delete する。
# config.toml の [[keys.command]]（type = "popup"）から呼ばれる。
#
# quick-action（herdr-plus）ではなく popup に置いているのは、選択に TTY が
# 要るため。quick-action はアクション実行直後に pane が破棄され、かつ
# herdr-plus が cmd.Stdin を繋がないので fzf が
# "inappropriate ioctl for device" で落ちる。
#
# usage: session-pick.sh <stop|delete>

set -euo pipefail

action="${1:-}"

case "${action}" in
    stop | delete) ;;
    *)
        printf 'usage: %s <stop|delete>\n' "${0##*/}" >&2
        exit 2
        ;;
esac

# default は運用の土台なので候補から外す（誤って落とせないようにする）。
targets=$(
    herdr session list --json |
    jq -r '.sessions[].name' |
    rg -v '^default$' || true
)

if [[ -z ${targets} ]]; then
    printf 'default 以外のセッションはありません\n'
    printf 'press enter to close '
    read -r _
    exit 0
fi

# Tab で複数選択。Esc でキャンセルすると空が返るので、その場合は何もしない。
selected=$(printf '%s\n' "${targets}" | fzf --multi --prompt="${action}> ") || true

if [[ -z ${selected} ]]; then
    exit 0
fi

# 選択された分だけ実行する。1 つ失敗しても残りは続ける。
while IFS= read -r name; do
    [[ -n ${name} ]] || continue
    if herdr session "${action}" "${name}"; then
        printf '%s: %s\n' "${action}" "${name}"
    else
        printf '%s failed: %s\n' "${action}" "${name}" >&2
    fi
done <<<"${selected}"

# 結果を読めるように閉じる前に待つ（popup は read で待たせられる）。
printf 'press enter to close '
read -r _
