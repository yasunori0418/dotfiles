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

# 自分が乗っているセッションは候補から外す（操作した瞬間に足元が消えるため）。
#
# herdr に「現在のセッション名」を直接返すコマンドは無いので、pane へ注入される
# HERDR_SOCKET_PATH と session list の socket_path を突き合わせて逆引きする。
sessions_json=$(herdr session list --json)

current=$(
    printf '%s' "${sessions_json}" |
    jq -r --arg sock "${HERDR_SOCKET_PATH:-}" \
        '.sessions[] | select(.socket_path == $sock) | .name'
)

# 逆引きに失敗したときは default を守る側に倒す（除外なしにすると
# 自分自身を落とせてしまうため、保守的に既定セッションを残す）。
if [[ -z ${current} ]]; then
    current="default"
fi

# herdr 側の制約に合わせて候補を絞る。取り違えると必ずエラーになる:
#   stop   … running なものだけ（停止済みは session_stop_failed）
#   delete … 停止済みのものだけ（running は session_delete_failed）
case "${action}" in
    stop) want_running=true ;;
    delete) want_running=false ;;
esac

targets=$(
    printf '%s' "${sessions_json}" |
    jq -r --arg current "${current}" --argjson running "${want_running}" \
        '.sessions[] | select(.name != $current and .running == $running) | .name'
)

if [[ -z ${targets} ]]; then
    if [[ ${action} == stop ]]; then
        printf '停止できるセッション（%s 以外で起動中）はありません\n' "${current}"
    else
        printf '削除できるセッション（停止済み）はありません\n'
        printf '起動中のものは先に stop（prefix+alt+x）してください\n'
    fi
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
