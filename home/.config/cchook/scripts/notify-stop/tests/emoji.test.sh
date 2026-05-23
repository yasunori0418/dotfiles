#!/usr/bin/env bash
# Verifies: emoji (incl. ZWJ sequences, regional indicators, skin tone modifiers,
# variation selectors) in a title survive end-to-end byte-for-byte.
set -euo pipefail
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
NOTIFY="$SCRIPT_DIR/../main.sh"
FIXTURE="$SCRIPT_DIR/emoji.test.jsonl"
EXPECTED="完了 🎉 👨‍💻 🇯🇵 ❤️ 👍🏻"

TMPBIN=$(mktemp -d)
trap 'rm -rf "$TMPBIN"' EXIT

cat > "$TMPBIN/osascript" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' "${@: -1}"
MOCK
cat > "$TMPBIN/dunstify" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' "$2"
MOCK
chmod +x "$TMPBIN/osascript" "$TMPBIN/dunstify"

ACTUAL=$(PATH="$TMPBIN:$PATH" "$NOTIFY" "$FIXTURE")

if [ "$ACTUAL" = "$EXPECTED" ]; then
    echo "PASS: $(basename "$0") -> '$ACTUAL'"
else
    echo "FAIL: $(basename "$0")"
    echo "  expected: '$EXPECTED' (bytes: $(printf '%s' "$EXPECTED" | xxd -p))"
    echo "  got:      '$ACTUAL' (bytes: $(printf '%s' "$ACTUAL" | xxd -p))"
    exit 1
fi
