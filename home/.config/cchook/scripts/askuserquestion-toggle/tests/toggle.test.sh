#!/usr/bin/env bash
# Verifies askuserquestion-toggle:
#   - "#aq-off" in prompt  -> marker created,  additionalContext non-empty
#   - "#aq-on"  in prompt  -> marker removed,  additionalContext non-empty
#   - both tokens          -> off wins (marker created)
#   - no token             -> empty output, marker untouched
set -euo pipefail
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
TOGGLE="$SCRIPT_DIR/../main.sh"

SID="test-$$-toggle"
MARKER="/tmp/cchook-no-askuserquestion.${SID}"
rm -f "$MARKER"
trap 'rm -f "$MARKER"' EXIT

fail=0
check() { # label cond
    if [ "$2" = "ok" ]; then
        echo "PASS: $(basename "$0")[$1]"
    else
        echo "FAIL: $(basename "$0")[$1]"
        fail=1
    fi
}
run() { printf '%s' "{\"session_id\":\"$SID\",\"prompt\":\"$1\"}" | "$TOGGLE"; }

# #aq-off -> marker created + context present
OUT=$(run "確認して #aq-off ね")
[ -e "$MARKER" ] && [ -n "$(printf '%s' "$OUT" | jq -r '.hookSpecificOutput.additionalContext // empty')" ] \
    && check "off" ok || check "off" ng

# #aq-on -> marker removed + context present
OUT=$(run "戻して #aq-on")
[ ! -e "$MARKER" ] && [ -n "$(printf '%s' "$OUT" | jq -r '.hookSpecificOutput.additionalContext // empty')" ] \
    && check "on" ok || check "on" ng

# both tokens -> off wins (marker created)
rm -f "$MARKER"
run "#aq-on と #aq-off が両方" >/dev/null
[ -e "$MARKER" ] && check "both-off-wins" ok || check "both-off-wins" ng

# no token -> empty output, marker untouched (still present from previous step)
OUT=$(run "普通の依頼です")
[ -z "$OUT" ] && [ -e "$MARKER" ] && check "no-token" ok || check "no-token" ng

exit "$fail"
