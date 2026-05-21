#!/usr/bin/env bash
# Verifies: a title with shell/AppleScript-special symbols (", \, $, `, etc.)
# survives end-to-end without re-evaluation or quoting damage.
set -euo pipefail
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
NOTIFY="$SCRIPT_DIR/../main.sh"
FIXTURE="$SCRIPT_DIR/symbols.test.jsonl"
EXPECTED='記号: "q" \b $v `c` (p) [b] | & ; * ? ! ~ < > '"'"'a'"'"

TMPBIN=$(mktemp -d)
trap 'rm -rf "$TMPBIN"' EXIT

# Use printf instead of echo to avoid backslash interpretation in some shells.
cat > "$TMPBIN/osascript" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' "${@: -1}"
MOCK
cat > "$TMPBIN/notify-send" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' "$2"
MOCK
chmod +x "$TMPBIN/osascript" "$TMPBIN/notify-send"

ACTUAL=$(PATH="$TMPBIN:$PATH" "$NOTIFY" "$FIXTURE")

if [ "$ACTUAL" = "$EXPECTED" ]; then
    echo "PASS: $(basename "$0") -> '$ACTUAL'"
else
    echo "FAIL: $(basename "$0")"
    echo "  expected: '$EXPECTED'"
    echo "  got:      '$ACTUAL'"
    exit 1
fi
