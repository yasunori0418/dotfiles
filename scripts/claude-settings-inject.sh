#!/usr/bin/env bash

# ~/.claude/inject/*.json の内容を ~/.claude/settings.json へマージする。
#
# settings.json は home-manager/claudeSettings.nix から生成した JSON を nput が
# 配置するが、その環境にしか存在しない値（接続先・資格情報など）は Nix 側に
# 置けない。そうした値は ~/.claude/inject/ に JSON として置き、このスクリプトが
# 配置後の settings.json へ後から重ねる。
#
# 各 JSON は settings.json のトップレベルからの部分木として書く。
# 例えば env を足すなら {"env": {"FOO": "bar"}}。ファイル名は任意で、
# 複数ある場合は辞書順に重ねる。マージ規則は以下。
#
#   object : 再帰的に深く合成する
#   array  : 置換せず、既存に無い要素だけを末尾へ追記する
#            （hooks.PreToolUse に matcher 付きの hook を足す、といった用途）
#   その他 : 後のファイルの値で上書きする
#
# 配列の重複判定は要素の丸ごと一致なので、inject 側の要素を書き換えると
# 古い要素は残ったまま新しい要素が足される。その場合は make nput-recopy で
# Nix 生成の JSON からやり直す。
# 何を注入するかはこのスクリプトの関心事ではないため、リポジトリ側には
# 注入する値もキー名も持たない。
#
# settings.json は nput の method = "copy"（place-once）で配置される。
# `nput apply --recopy` すると Nix 生成の JSON に戻って注入分が消えるため、
# 配置をやり直したあとは流し直す必要がある（Makefile の nput-recopy が続けて呼ぶ）。
#
# home-manager の activation（home-manager/inject-claude-settings.nix）と
# `make claude-settings-inject` の両方から同じ処理を呼ぶための実体。

set -euo pipefail

INJECT_DIR="${CLAUDE_INJECT_DIR:-${HOME}/.claude/inject}"
readonly INJECT_DIR

SETTINGS_FILE="${CLAUDE_SETTINGS_FILE:-${HOME}/.claude/settings.json}"
readonly SETTINGS_FILE

# switch は注入対象を持たないマシンでも通す必要があるため、
# 前提が欠けているときはスキップして正常終了する。
skip() {
    echo "claude-settings-inject: $1; skipped" >&2
    exit 0
}

command -v jq >/dev/null 2>&1 || skip "jq not found"
[[ -d ${INJECT_DIR} ]] || skip "${INJECT_DIR} not found"
[[ -f ${SETTINGS_FILE} ]] || skip "${SETTINGS_FILE} not found"
[[ -w ${SETTINGS_FILE} ]] || skip "${SETTINGS_FILE} is not writable"

# glob が展開されなかったときにリテラルを掴まないよう nullglob を使う。
shopt -s nullglob
fragments=("${INJECT_DIR}"/*.json)
shopt -u nullglob

[[ ${#fragments[@]} -gt 0 ]] || skip "no *.json under ${INJECT_DIR}"

# 壊れた JSON を 1 つ混ぜただけで settings.json を破損させないため、
# マージ前に全ファイルを検査する。
for fragment in "${fragments[@]}"; do
    jq -e 'type == "object"' "${fragment}" >/dev/null 2>&1 ||
    skip "${fragment} is not a JSON object"
done

# jq の `*` は配列を丸ごと置き換えるため、配列だけ追記にした再帰マージを自前で持つ。
# 同じ要素を毎回足さないのは、switch のたびに流れても結果が変わらないようにするため
# （下の「内容が変わらないなら書き換えない」判定がこれに依存する）。
# 引数を $ 付きにしているのは、素の引数だと呼び出し時ではなく使用箇所の `.` に対して
# 評価され、reduce の中で別のものを指してしまうため。
# scripts/claude-settings-diff.sh にも同じ定義があるので、変えるときは両方を揃える。
merged="$(jq -s '
    def merge($base; $frag):
        if ($base | type) == "object" and ($frag | type) == "object" then
            reduce ($frag | keys_unsorted[]) as $k ($base; .[$k] = merge($base[$k]; $frag[$k]))
        elif ($base | type) == "array" and ($frag | type) == "array" then
            $base + [$frag[] | select(IN($base[]) | not)]
        else
            $frag
        end;
    reduce .[] as $item ({}; merge(.; $item))
' "${SETTINGS_FILE}" "${fragments[@]}")"

# 内容が変わらないなら書き換えない（mtime を動かさない）。
if [[ ${merged} == "$(cat "${SETTINGS_FILE}")" ]]; then
    echo "claude-settings-inject: already up to date" >&2
    exit 0
fi

# 同一ディレクトリの一時ファイルへ書いてから rename する（部分書き込みで
# settings.json を壊さないため）。パーミッションは元ファイルに合わせる。
#
# パーミッションの複製は cp --preserve=mode に任せる。stat の書式指定は
# GNU（-c '%a'）と BSD（-f '%Lp'）で非互換で、この環境の PATH には
# coreutils の stat が入るため、どちらを先に試すかで壊れる。
tmp_file="$(mktemp "${SETTINGS_FILE}.inject.XXXXXX")"
trap 'rm -f "${tmp_file}"' EXIT
cp -p "${SETTINGS_FILE}" "${tmp_file}"
printf '%s\n' "${merged}" >"${tmp_file}"
mv -f "${tmp_file}" "${SETTINGS_FILE}"
trap - EXIT

echo "claude-settings-inject: merged ${#fragments[@]} file(s) into ${SETTINGS_FILE}" >&2
