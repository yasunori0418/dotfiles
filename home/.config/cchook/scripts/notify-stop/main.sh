#!/usr/bin/env bash
# cchook Stop event: extract the ai-title from the transcript and send a desktop notification (macOS / Linux).
set -euo pipefail

TRANSCRIPT="${1:-}"

extract_title() {
    [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ] || return 0
    jq -rs '[.[] | select(.type=="ai-title") | .aiTitle] | last // ""' "$TRANSCRIPT" 2>/dev/null
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
