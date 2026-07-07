#!/usr/bin/env bash
# git-guard/main.sh — PreToolUse guard。
# git rebase / git reset を「対応スキルの arm marker がある時だけ」通し、
# raw の force push を gh-push スキル経由へ誘導する。
#
# marker はスキルの arm スクリプトが置く:
#   rebase: rebase-flow の scripts/rebase-backup.sh → .git/rebase-flow.armed
#   reset:  reset-flow  の scripts/reset-arm.sh    → .git/reset-flow.armed
# いずれも「計画提示 → ユーザー承認 → backup/safety branch 作成」を通過した
# 証跡であり、これが無い実行は履歴書き換えの野良実行なのでブロックする。
#
# cchook から use_stdin: true で PreToolUse の JSON を受け取る。
# stdout の JSON がそのまま Claude Code への応答になる。cchook は
# permissionDecision を必須とする（無い/不正 JSON は fail-safe deny）ため、
# 「意見なし」は表現できない:
#   pass = permissionDecision: ask  → ユーザー確認へ（allow は権限バイパスに
#                                      なるため使わない。settings の ask とも整合）
#   deny = permissionDecision: deny → 実行ブロック（理由を Claude が読む）
#
# Usage: main.sh <rebase|reset|push>
set -euo pipefail

op="${1:?usage: main.sh <rebase|reset|push>}"
input=$(cat)

cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')

pass() {
    jq -cn --arg r "$1" \
        '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "ask", permissionDecisionReason: $r}}'
    exit 0
}
deny() {
    jq -cn --arg r "$1" \
        '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny", permissionDecisionReason: $r}}'
    exit 0
}

# push: raw の force push（--force / --force-with-lease / -f / +refspec）を拒否し、
# gh-push スキル（保護ブランチ拒否・明示 lease を script が強制）へ誘導する。
# 通常 push は意見なし → settings の ask に落ちる。
if [ "$op" = "push" ]; then
    if printf '%s' "$cmd" | grep -Eq -- 'push[^|;&]*(--force|[[:space:]]-f([[:space:]]|$)|[[:space:]]\+[[:graph:]])'; then
        deny "🚫 raw の force push は禁止。gh-push スキル（gh-push.sh push <branch> --force [--expect=<sha>]）経由でのみ実行可 — 保護ブランチ拒否と明示 lease が強制される。rebase 後の push は rebase-flow §7 の手順に従うこと。"
    fi
    pass "通常 push（force なし）— ユーザー確認へ"
fi

# 脱出経路は常時通す: --abort は「開始前に戻す」操作で、塞ぐと事故が悪化する
if [ "$op" = "rebase" ]; then
    case "$cmd" in
        *"rebase --abort"*) pass "脱出経路（git rebase --abort）— ユーザー確認へ" ;;
    esac
fi

# marker はコマンドが実行される repo（= セッション cwd の repo）側で探す。
# 複合コマンドで別 repo へ cd するケースは marker が見つからず deny に倒れる（安全側）。
if [ -n "$cwd" ] && [ -d "$cwd" ]; then
    cd "$cwd" 2>/dev/null || true
fi
marker=$(git rev-parse --git-path "${op}-flow.armed" 2>/dev/null) \
    || pass "git repo 外（git 自体が失敗するはず）— ユーザー確認へ"

skill="${op}-flow"
if [ ! -f "$marker" ]; then
    deny "🚫 git ${op} は ${skill} スキル経由でのみ実行可。${skill} スキルを起動し、計画提示 → ユーザー承認 → arm スクリプト（backup 作成 + 解錠）の後に再実行すること。$([ "$op" = "rebase" ] && echo 'git rebase --abort のみ常時許可。')"
fi

# TTL 30 分。期限切れ marker は解錠状態の放置なので消す
armed_at=$(cat "$marker" 2>/dev/null || echo 0)
case "$armed_at" in
    *[!0-9]*) armed_at=0 ;;
esac
now=$(date +%s)
if [ $((now - armed_at)) -gt 1800 ]; then
    rm -f "$marker"
    deny "🚫 ${skill} の解錠 marker が期限切れ（30 分）。${skill} のワークフロー（計画 → 承認 → arm）をやり直すこと。"
fi

pass "${skill} arm 済み（marker 有効）— ユーザー確認へ"
