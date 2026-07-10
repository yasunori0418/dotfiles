#!/usr/bin/env bash
# diff-reviewer の PreToolUse hook: Bash を読み取り専用コマンドに制限する。
# 許可リスト方式: 差分収集スクリプト(collect-diff.sh)、git の参照系サブコマンド、
# 基本テキスト処理のみ通し、それ以外・リダイレクトは exit 2 でブロック(stderr がエージェントに返る)。
set -euo pipefail

INPUT=$(cat)
COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty')
[[ -z "$COMMAND" ]] && exit 0

deny() {
    echo "Blocked (diff-reviewer is read-only): $1" >&2
    exit 2
}

# リダイレクトを拒否。stderr の /dev/null 捨てと 2>&1 のみ許可
STRIPPED=$(printf '%s' "$COMMAND" | sed -E 's#[0-9]*>>?[[:space:]]*(&[0-9]+|/dev/null)##g')
if [[ "$STRIPPED" == *'>'* ]]; then
    deny "リダイレクトによる書き込みは不可: ${COMMAND}"
fi

# パイプ・連結・コマンド置換を区切りに分割し、各コマンドの先頭語を検証
NORMALIZED=$(printf '%s' "$STRIPPED" | tr '\n`' ';;' | sed -E 's/\$\(/;/g; s/[()]/;/g; s/\|\|/;/g; s/&&/;/g; s/\|/;/g')

GIT_SUB_RE='^(diff|log|status|show|merge-base|ls-files|ls-tree|rev-parse|rev-list|symbolic-ref|blame|grep|shortlog|describe|for-each-ref|cat-file|name-rev)$'
UTIL_RE='^(rg|grep|head|tail|wc|sort|uniq|cut|tr|cat|ls|jq|echo|true|basename|dirname|readlink)$'
# 差分収集スクリプト(読み取り専用・stdout のみ)。~ / $HOME を展開した上で正規パスとの完全一致のみ許可
COLLECT_SH="$HOME/.claude/skills/diff-review/scripts/collect-diff.sh"

IFS=';' read -ra SEGMENTS <<< "$NORMALIZED"
for seg in "${SEGMENTS[@]}"; do
    seg="${seg#"${seg%%[![:space:]]*}"}"
    [[ -z "$seg" ]] && continue
    read -ra words <<< "$seg"
    first="${words[0]}"

    first_path="${first/#\~/$HOME}"
    first_path="${first_path/#\$HOME/$HOME}"
    if [[ "$first_path" == "$COLLECT_SH" ]]; then
        continue
    elif [[ "$first" == "git" ]]; then
        # グローバルフラグ(-C <path> / -c <k=v> 等)を飛ばしてサブコマンドを特定
        sub=""
        i=1
        while (( i < ${#words[@]} )); do
            w="${words[$i]}"
            case "$w" in
                -C | -c) i=$((i + 2)) ;;
                -*) i=$((i + 1)) ;;
                *)
                    sub="$w"
                    break
                    ;;
            esac
        done
        if ! [[ "$sub" =~ $GIT_SUB_RE ]]; then
            deny "git ${sub:-(サブコマンドなし)} は不可(参照系サブコマンドのみ許可)"
        fi
    elif ! [[ "$first" =~ $UTIL_RE ]]; then
        deny "コマンド ${first} は許可リスト外(git 参照系と基本テキスト処理のみ使用可)"
    fi
done

exit 0
