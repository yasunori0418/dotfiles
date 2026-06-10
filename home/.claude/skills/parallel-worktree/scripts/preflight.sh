#!/usr/bin/env bash
# parallel-worktree の事前確認（read-only）。
# wt/gh/tmux の有無、既定ブランチ、未コミット変更、既存 worktree/ブランチ名を
# 決定論的に収集する。worktree 生成やエージェント起動の前に必ず実行し、
# 出力の WARNING を解消してから進む。状態を変える操作は一切行わない。
set -u

section() { printf '\n=== %s ===\n' "$1"; }

section "TOOLS"
for t in wt gh tmux git; do
    if command -v "$t" >/dev/null 2>&1; then
        ver=$("$t" --version 2>/dev/null | head -1)
        printf '%-5s installed: yes  %s\n' "$t" "$ver"
    else
        printf '%-5s installed: no   WARNING: %s が無い\n' "$t" "$t"
    fi
done
if command -v gh >/dev/null 2>&1; then
    if gh auth status >/dev/null 2>&1; then
        echo "gh auth: ok"
    else
        echo "gh auth: NONE  WARNING: gh 未認証。PR 作成前に gh auth login が必要"
    fi
fi

section "REPO"
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "WARNING: git リポジトリ外。リポジトリ内で実行すること"
    exit 0
fi
echo "current branch: $(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
# 既定ブランチ（origin/HEAD → 無ければ main/master/develop を推測）
def=$(git symbolic-ref --quiet refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
if [ -z "${def:-}" ]; then
    for c in main master develop; do
        git show-ref --verify --quiet "refs/heads/$c" && def="$c" && break
    done
fi
echo "default branch: ${def:-（特定できず。--base を明示すること）}"
# develop が別に存在すれば候補として併記（stack の base 指定に使うことがある）
if git show-ref --verify --quiet refs/heads/develop && [ "${def:-}" != "develop" ]; then
    echo "candidate base: develop （git-flow 系。base に使うなら明示）"
fi

section "DIRTY (未コミット変更)"
dirty=$(git status --porcelain 2>/dev/null)
if [ -n "$dirty" ]; then
    echo "WARNING: プライマリ worktree に未コミット変更あり。"
    echo "  新しい worktree は base ブランチから切られるためこれらは引き継がれない。"
    echo "  先に commit / stash で捌くか、対象 worktree で作業すること。"
    echo "$dirty"
else
    echo "clean"
fi

section "EXISTING WORKTREES"
git worktree list 2>/dev/null || echo "(なし)"

section "EXISTING BRANCHES (名前衝突チェック用)"
# 提案するブランチ名がここに既出なら別名にする
git branch --format='%(refname:short)' 2>/dev/null
echo "--- remote ---"
git branch -r --format='%(refname:short)' 2>/dev/null | grep -v 'HEAD' || true
