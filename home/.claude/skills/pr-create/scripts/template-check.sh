#!/usr/bin/env bash
#
# template-check.sh — PR テンプレートと本文下書きの「骨組み」を照合し、
# テンプレの見出し・チェックリスト項目が削られたり勝手に足されていないかを
# 決定論的に検出する。read-only。
#
# なぜ必要か:
#   テンプレの遵守を文章ルールだけに委ねると、モデルは「このセクションは
#   該当しないから落とす」「見出しを言い換える」と加工してしまう。テンプレの
#   入力箇所は確定しているので、骨組み（見出し＋チェックリストのラベル）は
#   逐語で不変であるべき。ここで機械的な歯止めを入れ、drift があれば作成前に
#   止める。
#
# 骨組みの定義:
#   - 見出し行（# 〜 ######、行頭ハッシュ 1〜6 個 + 空白）
#   - チェックリスト項目（- / * + [ ] / [x]）。チェック状態は正規化して
#     無視し、ラベル文字列だけを比較する（[ ]→[x] は差分とみなさない）。
#   HTML コメント（<!-- ... -->）は「埋めた後に消す」慣習があるため照合対象外。
#
# Usage:
#   template-check.sh <template-file> <draft-body-file>
#
# 終了コード:
#   0 = OK（骨組み一致）
#   1 = DRIFT（見出し/チェック項目の欠落・追加・並べ替えを検出）
#   2 = 使い方エラー（引数不足・ファイル無し）
set -euo pipefail

if [ $# -ne 2 ]; then
    echo "Usage: template-check.sh <template-file> <draft-body-file>" >&2
    exit 2
fi

tmpl="$1"
draft="$2"
for f in "$tmpl" "$draft"; do
    [ -f "$f" ] || { echo "ERROR: ファイルが見つかりません: $f" >&2; exit 2; }
done

# 骨組み抽出。interval 正規表現（{1,6}）に依存しないよう awk 側で長さを数える。
skeleton() {
    awk '
    {
        line = $0
        # --- 見出し: 行頭ハッシュ 1〜6 個 + 空白 ---
        if (substr(line, 1, 1) == "#") {
            n = 0
            while (substr(line, n + 1, 1) == "#") n++
            c = substr(line, n + 1, 1)
            if (n >= 1 && n <= 6 && (c == " " || c == "\t")) {
                sub(/[ \t]+$/, "", line)
                print "H\t" line
                next
            }
        }
        # --- チェックリスト項目: 先頭空白 + -/* + [ ]/[x]/[X] ---
        t = line
        sub(/^[ \t]*/, "", t)
        if (t ~ /^[-*][ \t]+\[[ xX]\]/) {
            sub(/^[-*][ \t]+\[[ xX]\][ \t]*/, "", t)   # マーカーとチェック状態を除去
            sub(/[ \t]+$/, "", t)
            print "C\t" t
            next
        }
    }
    ' "$1"
}

ts=$(mktemp)
ds=$(mktemp)
trap 'rm -f "$ts" "$ds"' EXIT
skeleton "$tmpl" > "$ts"
skeleton "$draft" > "$ds"

count() { [ -z "$1" ] && echo 0 || printf '%s\n' "$1" | grep -c .; }
label() { case "$1" in H*) echo "見出し ${1#H$'\t'}";; C*) echo "チェック項目 ${1#C$'\t'}";; *) echo "$1";; esac; }

missing=$(comm -23 <(sort "$ts") <(sort "$ds") || true)
extra=$(comm -13 <(sort "$ts") <(sort "$ds") || true)
n_missing=$(count "$missing")
n_extra=$(count "$extra")

echo "=== TEMPLATE SKELETON ==="
if [ -s "$ts" ]; then while IFS= read -r l; do label "$l"; done < "$ts"; else echo "(見出し・チェック項目なし)"; fi
echo ""
echo "=== DRAFT SKELETON ==="
if [ -s "$ds" ]; then while IFS= read -r l; do label "$l"; done < "$ds"; else echo "(見出し・チェック項目なし)"; fi
echo ""

echo "=== DIFF ==="
if [ "$n_missing" -gt 0 ]; then
    echo "MISSING（テンプレにあるが下書きに無い＝削り違反。該当なしでも見出しは残す）:"
    while IFS= read -r l; do [ -n "$l" ] && echo "  - $(label "$l")"; done <<< "$missing"
fi
if [ "$n_extra" -gt 0 ]; then
    echo "EXTRA（下書きにあるがテンプレに無い＝勝手追加。補足はテンプレ末尾に最小限）:"
    while IFS= read -r l; do [ -n "$l" ] && echo "  - $(label "$l")"; done <<< "$extra"
fi
if [ "$n_missing" -eq 0 ] && [ "$n_extra" -eq 0 ]; then
    if diff -q "$ts" "$ds" >/dev/null 2>&1; then
        echo "(差分なし)"
    else
        echo "REORDER（見出し・チェック項目の並び順がテンプレと違う＝加工。テンプレ順に戻す）"
    fi
fi
echo ""

echo "=== RESULT ==="
if [ "$n_missing" -eq 0 ] && [ "$n_extra" -eq 0 ] && diff -q "$ts" "$ds" >/dev/null 2>&1; then
    echo "OK — 骨組みはテンプレと一致。承認フローに進んでよい。"
    exit 0
fi
echo "DRIFT DETECTED — テンプレの骨組みと不一致。下書きをテンプレ構造に戻してから再チェックする。"
echo "（入力箇所を埋める・[ ]→[x] にするのは可。見出し/チェック項目の削除・追加・改名・並べ替えは不可）"
exit 1
