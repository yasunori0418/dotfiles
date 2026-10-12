#!/usr/bin/env bash

# layat が配置した ~/.claude/mcp-servers.json の MCP サーバー定義を
# Claude Code の user スコープ（~/.claude.json）へ登録する。
#
# Claude Code は settings.json からサーバー定義を読まず、user スコープの定義は
# ~/.claude.json にしか置けない。~/.claude.json は Claude Code 自身が書き込む
# 状態ファイルなので layat では配置できず、`claude mcp` 経由で登録する。
#
# `claude mcp add-json` は同名が既にあると失敗し、`claude mcp remove` は対象が
# 無いと失敗する。よって ~/.claude.json の現状を jq で読み、サーバーごとに
#   - 定義が一致している : 何もしない（毎 switch 流しても ~/.claude.json を触らない）
#   - 定義が異なる       : remove してから add-json し直す
#   - 未登録             : add-json する
# を選ぶ。add-json は保存時に空の既定値（例: args を省くと "args": []）を補うため、
# 比較は双方から空の値（[] / {} / null）を落としてから行う。
#
# Nix 側から消したサーバーを残さないため、このスクリプトが登録した名前を
# 状態ファイルに記録し、前回記録にあって今回の定義に無い名前だけを remove する。
# 手で `claude mcp add` したサーバーは記録に載らないので触らない。
#
# home-manager の activation（home-manager/register-claude-mcp-servers.nix）と
# `make claude-mcp-register` の両方から同じ処理を呼ぶための実体。

set -euo pipefail

SERVERS_FILE="${CLAUDE_MCP_SERVERS_FILE:-${HOME}/.claude/mcp-servers.json}"
readonly SERVERS_FILE

# CLAUDE_CONFIG_DIR を設定すると Claude Code は ~/.claude.json ではなく
# その直下の .claude.json を使う。
CLAUDE_JSON="${CLAUDE_CONFIG_DIR:-${HOME}}/.claude.json"
readonly CLAUDE_JSON

STATE_FILE="${CLAUDE_MCP_REGISTER_STATE:-${XDG_STATE_HOME:-${HOME}/.local/state}/claude-mcp-register/managed.json}"
readonly STATE_FILE

# claude の在り処は呼び出し元によって解決手段が違う。
#   - home-manager の activation: systemd の service が PATH を最小構成へ固定するので
#     PATH 解決では見つからない。Nix 側で解決した絶対パスを CLAUDE_BIN で渡してもらう。
#   - `make claude-mcp-register`（対話シェル）: PATH から引ければ十分。
CLAUDE_BIN="${CLAUDE_BIN:-$(command -v claude || true)}"
readonly CLAUDE_BIN

# switch は前提が揃っていないマシンでも通す必要があるため、
# 欠けているときはスキップして正常終了する。
skip() {
    echo "claude-mcp-register: $1; skipped" >&2
    exit 0
}

command -v jq >/dev/null 2>&1 || skip "jq not found"
[[ -n ${CLAUDE_BIN} && -x ${CLAUDE_BIN} ]] || skip "claude not found (set CLAUDE_BIN to override)"
[[ -f ${SERVERS_FILE} ]] || skip "${SERVERS_FILE} not found"
jq -e 'type == "object"' "${SERVERS_FILE}" >/dev/null 2>&1 ||
skip "${SERVERS_FILE} is not a JSON object"

# ~/.claude.json は Claude Code を一度も起動していなければ存在しない。
current='{}'
if [[ -f ${CLAUDE_JSON} ]]; then
    current="$(jq -c '.mcpServers // {}' "${CLAUDE_JSON}")"
fi

previous='[]'
if [[ -f ${STATE_FILE} ]]; then
    previous="$(jq -c 'if type == "array" then . else [] end' "${STATE_FILE}" 2>/dev/null || echo '[]')"
fi

# add-json が保存時に補う空の既定値を比較から除くための正規化。
# beautysh が複数行の jq プログラムを解釈できないため、jq の式は 1 行で変数に置く。
# shellcheck disable=SC2016
readonly JQ_SAME='def strip: with_entries(select(.value | IN([], {}, null) | not)); ($a | strip) == ($b | strip)'
# 前回このスクリプトが登録し、今回の定義から消え、まだ ~/.claude.json に残る名前。
# shellcheck disable=SC2016
readonly JQ_STALE='$prev[] as $n | select(($want[0] | has($n)) | not) | select($cur | has($n)) | $n'

failed=0

# macOS の /usr/bin/env bash は 3.2 に解決されうるので mapfile は使わず while read で回す。
# here-string は空文字列でも 1 行として渡すため、空行は読み飛ばす。
# ループの標準入力を claude に食われないよう、claude は </dev/null で呼ぶ。
desired="$(jq -r 'keys[]' "${SERVERS_FILE}")"
while IFS= read -r name; do
    [[ -n ${name} ]] || continue

    want="$(jq -c --arg n "${name}" '.[$n]' "${SERVERS_FILE}")"
    have="$(jq -c --arg n "${name}" '.[$n]' <<<"${current}")"

    if [[ ${have} != null ]]; then
        if jq -en --argjson a "${want}" --argjson b "${have}" "${JQ_SAME}" >/dev/null; then
            continue
        fi
        if ! "${CLAUDE_BIN}" mcp remove --scope user "${name}" </dev/null >/dev/null; then
            echo "claude-mcp-register: failed to remove outdated ${name}" >&2
            failed=$((failed + 1))
            continue
        fi
    fi

    if "${CLAUDE_BIN}" mcp add-json --scope user "${name}" "${want}" </dev/null >/dev/null; then
        echo "claude-mcp-register: registered ${name}"
    else
        # 1 つのサーバーの失敗で他の登録や switch 全体を巻き込まない。
        echo "claude-mcp-register: failed to register ${name}" >&2
        failed=$((failed + 1))
    fi
done <<<"${desired}"

# 前回このスクリプトが登録し、今回の定義から消えた名前だけを外す。
# remove に失敗した名前は次回また試せるよう記録に残す。
stale="$(jq -rn --argjson prev "${previous}" --argjson cur "${current}" --slurpfile want "${SERVERS_FILE}" "${JQ_STALE}")"
kept='[]'
while IFS= read -r name; do
    [[ -n ${name} ]] || continue

    if "${CLAUDE_BIN}" mcp remove --scope user "${name}" </dev/null >/dev/null; then
        echo "claude-mcp-register: removed ${name}"
    else
        echo "claude-mcp-register: failed to remove ${name}" >&2
        kept="$(jq -c --arg n "${name}" '. + [$n]' <<<"${kept}")"
        failed=$((failed + 1))
    fi
done <<<"${stale}"

managed="$(jq -cn --argjson kept "${kept}" --slurpfile want "${SERVERS_FILE}" '$kept + ($want[0] | keys) | unique')"

# 内容が変わらないなら書き換えない。部分書き込みで記録を壊さないよう
# 同一ディレクトリの一時ファイルへ書いてから rename する。
if [[ ! -f ${STATE_FILE} || ${managed} != "$(cat "${STATE_FILE}")" ]]; then
    mkdir -p "$(dirname "${STATE_FILE}")"
    tmp_file="$(mktemp "${STATE_FILE}.XXXXXX")"
    trap 'rm -f "${tmp_file}"' EXIT
    printf '%s\n' "${managed}" >"${tmp_file}"
    mv -f "${tmp_file}" "${STATE_FILE}"
    trap - EXIT
fi

if [[ ${failed} -gt 0 ]]; then
    echo "claude-mcp-register: ${failed} operation(s) failed" >&2
fi
