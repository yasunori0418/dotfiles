#!/usr/bin/env bash
# askuserquestion-guard/main.sh — PreToolUse guard for AskUserQuestion.
#
# AskUserQuestion をセッション単位で無効化する。remote-control 経由のスマホ/web
# セッションでは、質問文・選択肢の文脈が選択 UI の前に表示されない挙動があるため、
# そのセッションだけテキスト質問へ倒したい。判定マーカーは
#   /tmp/cchook-no-askuserquestion.<session_id>
# でセッションごとに独立。作成/削除は askuserquestion-toggle（UserPromptSubmit で
# プロンプトに #aq-off / #aq-on）が行う。/tmp なので再起動で消え既定（有効）へ復帰。
# 従来の PC 全体マーカー（/tmp/cchook-no-askuserquestion）は廃止（後方互換なし）。
#
# cchook から use_stdin: true で PreToolUse の JSON を受け取り、stdout の JSON が
# そのまま Claude Code への応答になる。cchook の command アクションは
#   コマンド成功 + 空出力 → {continue:true}（＝意見なし・通常進行）
#   コマンド成功 + deny JSON → その決定を適用
#   コマンド失敗 or 非 JSON 出力 → fail-safe deny
# なので「意見なし」は空出力で表現する:
#   マーカー無し → 何も出さず exit 0 → 通常どおり進む
#   マーカー有り → permissionDecision: deny（テキスト質問へ倒す指示を Claude が読む）
set -euo pipefail

input=$(cat)
sid=$(printf '%s' "$input" | jq -r '.session_id // empty')

# session_id 不明、またはこのセッションのマーカー不在なら意見なし（沈黙 → 通常進行）
[ -n "$sid" ] || exit 0
marker="/tmp/cchook-no-askuserquestion.${sid}"
[ -e "$marker" ] || exit 0

jq -cn '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: "このセッションでは AskUserQuestion は無効化されている（#aq-on で再有効化）。選択肢はメッセージ本文に番号付きで列挙し、ユーザーには番号または自由記述での回答を求めること。"
  }
}'
