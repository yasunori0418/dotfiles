#!/usr/bin/env bash
# Verifies: when last assistant text contains a '# Heading', SUMMARY equals the heading.
set -euo pipefail
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
NOTIFY="$SCRIPT_DIR/../main.sh"
FIXTURE="$SCRIPT_DIR/with-title.test.jsonl"
EXPECTED="テストタイトル"

TMPBIN=$(mktemp -d)
trap 'rm -rf "$TMPBIN"' EXIT

cat > "$TMPBIN/osascript" <<'MOCK'
#!/usr/bin/env bash
echo "${@: -1}"
MOCK
cat > "$TMPBIN/notify-send" <<'MOCK'
#!/usr/bin/env bash
echo "$2"
MOCK
chmod +x "$TMPBIN/osascript" "$TMPBIN/notify-send"

ACTUAL=$(PATH="$TMPBIN:$PATH" "$NOTIFY" "$FIXTURE")

if [ "$ACTUAL" = "$EXPECTED" ]; then
  echo "PASS: $(basename "$0") -> '$ACTUAL'"
else
  echo "FAIL: $(basename "$0") expected '$EXPECTED', got '$ACTUAL'"
  exit 1
fi
