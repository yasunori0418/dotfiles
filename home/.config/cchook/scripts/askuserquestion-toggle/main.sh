#!/usr/bin/env bash
# askuserquestion-toggle/main.sh — UserPromptSubmit hook.
#
# プロンプトに含まれるマジックトークンで、そのセッションの AskUserQuestion 無効化
# マーカー（/tmp/cchook-no-askuserquestion.<session_id>）を作成/削除する。
#   #aq-off → 無効化（マーカー作成）
#   #aq-on  → 再有効化（マーカー削除）
# セッション単位なので、同一 PC・同一プロジェクトの並行セッションには影響しない。
# session_id は Bash 環境変数には無く、cchook が stdin JSON で渡すためここで解決する。
# 両方のトークンが含まれる場合は #aq-off を優先（無効化を安全側とみなす）。
#
# cchook から use_stdin: true で UserPromptSubmit の JSON を受け取る。トークンを
# 検出したときだけ additionalContext で結果を Claude に伝え、それ以外は沈黙する。
set -euo pipefail

input=$(cat)
sid=$(printf '%s' "$input" | jq -r '.session_id // empty')
prompt=$(printf '%s' "$input" | jq -r '.prompt // empty')
[ -n "$sid" ] || exit 0

marker="/tmp/cchook-no-askuserquestion.${sid}"
case "$prompt" in
    *"#aq-off"*)
        : > "$marker"
        msg="AskUserQuestion をこのセッションで無効化した。以後この質問はテキスト（本文に番号付き列挙）で行い、番号または自由記述での回答を求めること。#aq-on で再有効化。"
        ;;
    *"#aq-on"*)
        rm -f "$marker"
        msg="AskUserQuestion をこのセッションで再有効化した。"
        ;;
    *)
        exit 0
        ;;
esac

jq -cn --arg m "$msg" '{
  hookSpecificOutput: {
    hookEventName: "UserPromptSubmit",
    additionalContext: $m
  }
}'
