#!/usr/bin/env bash
#
# reset-arm.sh — reset 実行直前の safety branch を作成し、cchook guard の
# 解錠 marker（30 分有効）を置く。reset 本体は実行しない。
#
# Usage: reset-arm.sh [--allow-dirty]
#   --allow-dirty: 未コミット変更がある状態での arm を許可する。
#                  --hard で dirty を意図的に破棄する計画が承認済みの場合のみ。
set -euo pipefail

allow_dirty=0
for a in "$@"; do
    case "$a" in
        --allow-dirty) allow_dirty=1 ;;
        *)
            echo "ERROR: 不明なオプション: $a" >&2
            exit 1
            ;;
    esac
done

git rev-parse --git-dir >/dev/null 2>&1 || { echo "ERROR: git リポジトリ内で実行してください" >&2; exit 1; }

current=$(git rev-parse --abbrev-ref HEAD)
if [ "$current" = "HEAD" ]; then
    echo "ERROR: detached HEAD 状態では arm しません" >&2
    exit 1
fi
# 保護ブランチでは arm しない（context の BLOCKER を素通りした直叩きを塞ぐ）
case "$current" in
    main | master | develop | development | trunk | release | release/* | releases/*)
        echo "ERROR: 保護ブランチ ($current) では arm しません。reset は作業ブランチのみ" >&2
        exit 1
        ;;
esac
if def=$(git symbolic-ref --quiet refs/remotes/origin/HEAD 2>/dev/null) \
    && [ "${def#refs/remotes/origin/}" = "$current" ]; then
    echo "ERROR: リモート既定ブランチ ($current) では arm しません" >&2
    exit 1
fi

dirty=$(git status --porcelain --untracked-files=no | wc -l)
if [ "$dirty" -gt 0 ] && [ "$allow_dirty" -ne 1 ]; then
    echo "ERROR: 未コミット変更 ${dirty} ファイルあり。--hard なら完全消滅する。" >&2
    echo "       破棄する計画が承認済みの場合のみ --allow-dirty を付けて再実行。" >&2
    exit 1
fi

ts=$(date +%Y%m%d-%H%M%S)
name="backup/reset/${current}-${ts}"
n=1
while git show-ref --verify --quiet "refs/heads/$name"; do
    name="backup/reset/${current}-${ts}-${n}"
    n=$((n + 1))
done
git branch "$name" HEAD

marker=$(git rev-parse --git-path reset-flow.armed)
date +%s > "$marker"

echo "=== SAFETY ==="
echo "branch: $name"
echo "sha: $(git rev-parse HEAD)"
echo "armed: $marker（30 分有効 — git reset が cchook guard を通過可能になる）"
if [ "$dirty" -gt 0 ]; then
    echo "NOTE: 未コミット変更 ${dirty} ファイルは safety branch では守られない（--hard で消えたら復旧不能）"
fi
echo ""
echo "=== RECOVERY ==="
echo "reset を取り消す: reset-flow で target=$name として再度 reset（コミット分は完全復旧）"
echo "NOTE: この safety branch はユーザーの明示承認があるまで削除しないこと"
