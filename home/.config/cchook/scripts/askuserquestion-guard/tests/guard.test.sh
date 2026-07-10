#!/usr/bin/env bash
# Verifies askuserquestion-guard:
#   - marker present for the session   -> permissionDecision: deny
#   - marker absent                    -> empty output (意見なし・通常進行)
#   - session_id missing               -> empty output
set -euo pipefail
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
GUARD="$SCRIPT_DIR/../main.sh"

SID="test-$$-guard"
MARKER="/tmp/cchook-no-askuserquestion.${SID}"
rm -f "$MARKER"
trap 'rm -f "$MARKER"' EXIT

fail=0
check() { # label expected actual
    if [ "$2" = "$3" ]; then
        echo "PASS: $(basename "$0")[$1] -> '$3'"
    else
        echo "FAIL: $(basename "$0")[$1] expected '$2', got '$3'"
        fail=1
    fi
}

# marker present -> deny
: > "$MARKER"
OUT=$(printf '%s' "{\"session_id\":\"$SID\",\"tool_name\":\"AskUserQuestion\",\"tool_input\":{}}" | "$GUARD")
DECISION=$(printf '%s' "$OUT" | jq -r '.hookSpecificOutput.permissionDecision // empty')
check "present" "deny" "$DECISION"

# marker absent -> empty output
rm -f "$MARKER"
OUT=$(printf '%s' "{\"session_id\":\"$SID\",\"tool_name\":\"AskUserQuestion\",\"tool_input\":{}}" | "$GUARD")
check "absent" "" "$OUT"

# session_id missing -> empty output (should not touch any marker)
OUT=$(printf '%s' '{"tool_name":"AskUserQuestion","tool_input":{}}' | "$GUARD")
check "no-session" "" "$OUT"

exit "$fail"
