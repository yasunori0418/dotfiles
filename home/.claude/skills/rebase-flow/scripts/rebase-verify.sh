#!/usr/bin/env bash
#
# rebase-verify.sh — rebase 実行後の機械検証。リポジトリは変更しない
# （rebase-backup.sh が置いた解錠 marker の除去のみ行う）。
#
# Usage: rebase-verify.sh <backup-ref> [base-ref]
#   backup-ref: rebase-backup.sh が作成した backup ブランチ
#   base-ref:   rebase-context.sh に渡したものと同じ base-ref。
#               渡すと onto 型でも比較範囲が正確になる（推奨）。
set -euo pipefail

[ $# -ge 1 ] || { echo "Usage: rebase-verify.sh <backup-ref> [base-ref]" >&2; exit 1; }
backup="$1"
base_ref="${2:-}"

git rev-parse --verify --quiet "${backup}^{commit}" >/dev/null \
    || { echo "ERROR: backup ref '$backup' を解決できません" >&2; exit 1; }

echo "=== STATE ==="
for p in rebase-merge rebase-apply; do
    if [ -e "$(git rev-parse --git-path "$p")" ]; then
        echo "BLOCKER: rebase が完了していません（$p が存在）。--continue / --abort で終わらせてから検証する"
        exit 0
    fi
done
echo "rebase 完了状態（進行中の操作なし）"
# rebase は完了したので guard の解錠 marker を除去（再 rebase には再度 backup が必要）
rm -f "$(git rev-parse --git-path rebase-flow.armed)"
echo ""

mb=$(git merge-base "$backup" HEAD)
new_mb="$mb"
if [ -n "$base_ref" ]; then
    if base_sha=$(git rev-parse --verify --quiet "${base_ref}^{commit}"); then
        new_mb=$(git merge-base "$base_sha" HEAD)
    else
        echo "WARNING: base-ref '$base_ref' を解決できず、比較範囲が不正確になる可能性"
    fi
fi

echo "=== COMMIT COUNT ==="
echo "before (backup): $(git rev-list --count "$mb".."$backup") 件"
echo "after  (HEAD):   $(git rev-list --count "$new_mb"..HEAD) 件"
echo ""

echo "=== TREE IDENTITY ==="
if git diff --quiet "$backup" HEAD; then
    echo "identical: yes — 最終状態のファイル内容は rebase 前と完全一致"
    echo "(history-edit 型は yes が合格条件。drop を含む計画は除く)"
else
    echo "identical: no — 最終状態に差分あり"
    echo "(onto 型は base の新規コミット分が乗るため no が正常。history-edit 型で no の場合、差分が drop 意図分のみか要精査)"
    echo ""
    git diff --stat "$backup" HEAD | tail -30 || true
fi
echo ""

echo "=== RANGE DIFF（before/after のコミット対応） ==="
echo "読み方: '=' 同一 / '!' 内容差あり / '<' 消失（計画に無い drop なら異常） / '>' 新規"
if [ -n "$base_ref" ] && [ "$new_mb" != "$mb" ]; then
    git range-diff "$mb".."$backup" "$new_mb"..HEAD || echo "(range-diff 失敗)"
else
    git range-diff "$backup"...HEAD || echo "(range-diff 失敗)"
fi
echo ""

echo "=== NEW LOG ==="
git log --oneline --no-decorate "$new_mb"..HEAD
