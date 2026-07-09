#!/usr/bin/env bash
#
# rebase-backup.sh — rebase 実行直前のバックアップブランチを作成し、
# 復旧コマンドを出力する。rebase 本体は実行しない。
#
# Usage: rebase-backup.sh
set -euo pipefail

git rev-parse --git-dir >/dev/null 2>&1 || { echo "ERROR: git リポジトリ内で実行してください" >&2; exit 1; }

current=$(git rev-parse --abbrev-ref HEAD)
if [ "$current" = "HEAD" ]; then
    echo "ERROR: detached HEAD 状態では backup を作成しません" >&2
    exit 1
fi
# 保護ブランチでは arm しない（context の BLOCKER を素通りした直叩きを塞ぐ）
case "$current" in
    main | master | develop | development | trunk | release | release/* | releases/*)
        echo "ERROR: 保護ブランチ ($current) では backup/arm しません。rebase は作業ブランチのみ" >&2
        exit 1
        ;;
esac
if def=$(git symbolic-ref --quiet refs/remotes/origin/HEAD 2>/dev/null) \
    && [ "${def#refs/remotes/origin/}" = "$current" ]; then
    echo "ERROR: リモート既定ブランチ ($current) では backup/arm しません" >&2
    exit 1
fi
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "ERROR: working tree が clean ではありません。backup 作成を中止（rebase-context.sh の BLOCKER を先に解消すること）" >&2
    exit 1
fi

ts=$(date +%Y%m%d-%H%M%S)
name="backup/rebase/${current}-${ts}"
n=1
while git show-ref --verify --quiet "refs/heads/$name"; do
    name="backup/rebase/${current}-${ts}-${n}"
    n=$((n + 1))
done
git branch "$name" HEAD

# cchook の git-guard を解錠する marker（30 分有効）。
# これが「backup なしで git rebase を実行できない」ことの機械的担保になる。
marker=$(git rev-parse --git-path rebase-flow.armed)
date +%s > "$marker"

echo "=== BACKUP ==="
echo "branch: $name"
echo "sha: $(git rev-parse HEAD)"
echo "armed: ${marker}（30 分有効 — git rebase が cchook guard を通過可能になる）"
if upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null); then
    echo "upstream-tip: $(git rev-parse "$upstream") ($upstream — force-push 時の lease 候補)"
fi
echo ""
echo "=== RECOVERY ==="
echo "rebase 進行中に中断する : git rebase --abort"
echo "rebase 完了後に全て戻す : git reset --hard $name   # ユーザー実行（要 clean tree）"
echo "検証                    : bash <skill-dir>/scripts/rebase-verify.sh $name <base-ref>"
echo ""
echo "NOTE: この backup ブランチはユーザーの明示承認があるまで削除しないこと"
