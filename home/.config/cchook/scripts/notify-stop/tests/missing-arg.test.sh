#!/usr/bin/env bash
# Verifies: when called with no transcript arg (or a non-existent file),
# SUMMARY falls back to 'Claude Code 完了' without erroring.
set -euo pipefail
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
NOTIFY="$SCRIPT_DIR/../main.sh"
EXPECTED="Claude Code 完了"

TMPBIN=$(mktemp -d)
trap 'rm -rf "$TMPBIN"' EXIT

cat > "$TMPBIN/osascript" <<'MOCK'
#!/usr/bin/env bash
echo "${@: -1}"
MOCK
cat > "$TMPBIN/dunstify" <<'MOCK'
#!/usr/bin/env bash
echo "$2"
MOCK
chmod +x "$TMPBIN/osascript" "$TMPBIN/dunstify"

fail=0
for case_label in "no-arg" "missing-file"; do
    case "$case_label" in
        no-arg)        ACTUAL=$(PATH="$TMPBIN:$PATH" "$NOTIFY") ;;
        missing-file)  ACTUAL=$(PATH="$TMPBIN:$PATH" "$NOTIFY" "/tmp/__notify_stop_nonexistent__.jsonl") ;;
    esac
    if [ "$ACTUAL" = "$EXPECTED" ]; then
        echo "PASS: $(basename "$0")[$case_label] -> '$ACTUAL'"
    else
        echo "FAIL: $(basename "$0")[$case_label] expected '$EXPECTED', got '$ACTUAL'"
        fail=1
    fi
done

exit "$fail"
