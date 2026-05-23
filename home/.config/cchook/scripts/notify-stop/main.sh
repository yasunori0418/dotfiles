#!/usr/bin/env bash
# cchook Stop event: extract the first H1 heading from the latest assistant
# text response and send a desktop notification (macOS / Linux).
set -euo pipefail

TRANSCRIPT="${1:-}"

extract_title() {
    [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ] || return 0
    jq -rs '
    [.[] | select(.type=="assistant") | .message.content[]? | select(.type=="text") | .text] | last
    | split("\n") | map(select(startswith("# "))) | (.[0] // "")
    | sub("^# "; "")
  ' "$TRANSCRIPT" 2>/dev/null
}

SUMMARY="$(extract_title)"
[ -z "$SUMMARY" ] && SUMMARY="Claude Code 完了"

case "$(uname)" in
    Darwin)
        osascript \
            -e 'on run argv' \
            -e 'display notification (item 1 of argv) with title "claude-code"' \
            -e 'end run' \
            "$SUMMARY"
        ;;
    Linux)
        dunstify "claude-code" "$SUMMARY"
        ;;
esac
