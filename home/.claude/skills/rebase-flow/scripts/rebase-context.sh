#!/usr/bin/env bash
#
# rebase-context.sh — rebase 計画に必要な情報とガードレール判定材料を
# まとめて出力する。リポジトリの参照・working tree は一切変更しない
# （merge-tree がオブジェクトを書くが参照は作らず、gc で回収される）。
#
# Usage:
#   rebase-context.sh <base-ref>
#     base-ref:
#       - onto 型（ブランチ更新）: rebase 先 ref（例: origin/main, main）
#       - 履歴整理型（interactive）: 書き換え範囲の直前コミット（例: HEAD~5, SHA）
#
# 出力は `=== SECTION ===` 区切りのプレーンテキスト。
#   BLOCKER: が 1 行でもあれば rebase 計画に進んではならない。
#   WARNING: は全て計画に明記して承認対象に含める。
set -euo pipefail

if [ $# -lt 1 ]; then
    echo "Usage: rebase-context.sh <base-ref>" >&2
    exit 1
fi
base_ref="$1"

blockers=0
warnings=0
blocker() { echo "BLOCKER: $*"; blockers=$((blockers + 1)); }
warning() { echo "WARNING: $*"; warnings=$((warnings + 1)); }

print_summary() {
    echo "=== SUMMARY ==="
    echo "blockers: $blockers / warnings: $warnings"
    if [ "$blockers" -gt 0 ]; then
        echo "判定: BLOCKER あり — rebase 計画に進まないこと。解消後に再実行"
    elif [ "$warnings" -gt 0 ]; then
        echo "判定: WARNING あり — 全て計画に明記し、承認対象に含めること"
    else
        echo "判定: ガードレール上の支障なし — 計画提示へ"
    fi
}

if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "ERROR: git リポジトリ内で実行してください" >&2
    exit 1
fi

echo "=== GIT VERSION ==="
git version
# merge-tree --write-tree（コンフリクト予測）は git 2.38+
# -h は exit 129 のため pipefail 対策で || true を挟む
if { git merge-tree -h 2>&1 || true; } | grep -q -- '--write-tree'; then
    merge_tree_ok=yes
else
    merge_tree_ok=no
fi
echo "conflict-prediction (merge-tree --write-tree): $merge_tree_ok"
echo ""

echo "=== REPO IDENTITY ==="
echo "worktree-root: $(git rev-parse --show-toplevel)"
echo "remote: $(git remote get-url origin 2>/dev/null || echo '(なし)')"
echo ""

echo "=== CURRENT BRANCH ==="
current=$(git rev-parse --abbrev-ref HEAD)
if [ "$current" = "HEAD" ]; then
    blocker "detached HEAD 状態。ブランチをチェックアウトしてから実行する"
    echo ""
    print_summary
    exit 0
fi
echo "branch: $current"
echo "head: $(git rev-parse HEAD)"
# 保護ブランチ判定: 静的リスト + リモート既定ブランチ（origin/HEAD → gh fallback）。
# rebase / reset / force-push が許されるのは作業ブランチのみ。
protected_reason() {
    local b="$1" def
    case "$b" in
        main | master | develop | development | trunk | release | release/* | releases/*)
            echo "静的リスト"
            return 0
            ;;
    esac
    if def=$(git symbolic-ref --quiet refs/remotes/origin/HEAD 2>/dev/null); then
        if [ "${def#refs/remotes/origin/}" = "$b" ]; then
            echo "origin/HEAD（リモート既定ブランチ）"
            return 0
        fi
    elif command -v gh >/dev/null 2>&1; then
        def=$(gh repo view --json defaultBranchRef --jq .defaultBranchRef.name 2>/dev/null || true)
        if [ -n "$def" ] && [ "$def" = "$b" ]; then
            echo "GitHub 既定ブランチ"
            return 0
        fi
    fi
    return 1
}
if preason=$(protected_reason "$current"); then
    blocker "保護ブランチ ($current — $preason) 上での rebase は禁止。作業ブランチでのみ実行可"
fi
echo ""

echo "=== IN-PROGRESS OPERATIONS ==="
op_found=no
for p in rebase-merge rebase-apply MERGE_HEAD CHERRY_PICK_HEAD REVERT_HEAD BISECT_LOG; do
    if [ -e "$(git rev-parse --git-path "$p")" ]; then
        blocker "進行中の操作あり: $p（完了または中断してから実行する）"
        op_found=yes
    fi
done
[ "$op_found" = no ] && echo "(なし)"
echo ""

echo "=== WORKING TREE ==="
if ! git diff --quiet || ! git diff --cached --quiet; then
    blocker "未コミットの変更あり。commit / stash してから実行する（autostash は使わない）"
    git status --short | head -20 || true
else
    echo "clean"
fi
untracked=$(git ls-files --others --exclude-standard | wc -l)
echo "untracked: ${untracked} 件"
echo "stash: $(git stash list | wc -l) 件"
echo ""

echo "=== BASE REF ==="
if ! base_sha=$(git rev-parse --verify --quiet "${base_ref}^{commit}"); then
    echo "ERROR: base-ref '$base_ref' を解決できません" >&2
    exit 1
fi
echo "base-ref: $base_ref ($base_sha)"
if ! merge_base=$(git merge-base "$base_sha" HEAD); then
    blocker "base-ref と HEAD に共通祖先がありません（base-ref の指定誤りの可能性）"
    echo ""
    print_summary
    exit 0
fi
if [ "$merge_base" = "$base_sha" ]; then
    rtype="history-edit"
    echo "type: history-edit（base は HEAD の祖先 — その場での履歴整理）"
else
    rtype="onto"
    echo "type: onto（base が分岐/前進している — 乗せ替え）"
    echo "merge-base: $merge_base"
    echo "base 側の新規コミット: $(git rev-list --count "$merge_base".."$base_sha") 件"
fi
echo ""

echo "=== REWRITE RANGE（書き換え対象コミット・古い順が下） ==="
range_count=$(git rev-list --count "$merge_base"..HEAD)
echo "count: $range_count"
if [ "$range_count" -eq 0 ]; then
    blocker "書き換え対象コミットが 0 件（rebase の必要なし、または base-ref の指定誤り）"
else
    git log --oneline --no-decorate "$merge_base"..HEAD
fi
echo ""

echo "=== PUSH STATUS ==="
if upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null); then
    echo "upstream: $upstream"
    counts=$(git rev-list --left-right --count "$upstream"...HEAD)
    behind=$(echo "$counts" | awk '{print $1}')
    ahead=$(echo "$counts" | awk '{print $2}')
    echo "ahead: $ahead / behind: $behind"
    if [ "$behind" -gt 0 ]; then
        warning "upstream に未取り込みのコミット ${behind} 件（他者の push の可能性。取り込み要否を確認）"
    fi
    if [ "$range_count" -gt 0 ]; then
        unpushed_in_range=$(git rev-list --count "$merge_base"..HEAD --not "$upstream")
        pushed_in_range=$((range_count - unpushed_in_range))
        if [ "$pushed_in_range" -gt 0 ]; then
            warning "push 済みコミット ${pushed_in_range} 件が書き換え対象。リモート反映には force-push (--force-with-lease) が必要"
        else
            echo "書き換え対象は全て未 push（force-push 不要）"
        fi
    fi
else
    echo "upstream: (未設定 — リモート未 push。force-push の問題なし)"
fi
echo ""

echo "=== OPEN PR ==="
if command -v gh >/dev/null 2>&1; then
    pr_state=$(gh pr view --json state --jq .state 2>/dev/null || echo "")
    if [ "$pr_state" = "OPEN" ]; then
        gh pr view --json number,title,isDraft,reviewDecision \
            --jq '"#\(.number) [\(if .isDraft then "draft" else "open" end)] reviewDecision=\(.reviewDecision // "none") \(.title)"' \
            2>/dev/null || true
        warning "このブランチに open PR あり。force-push はレビューコメントの文脈・レビュー履歴に影響する"
    elif [ -n "$pr_state" ]; then
        echo "PR あり（state: $pr_state — open ではない）"
    else
        echo "(PR なし、または取得失敗)"
    fi
else
    echo "(gh 未導入 — PR 状態は手動確認)"
fi
echo ""

echo "=== CHILD BRANCHES（書き換え範囲に依存するブランチ） ==="
if [ "$range_count" -gt 0 ]; then
    first_commit=$(git rev-list "$merge_base"..HEAD | tail -1)
    children=$(git branch --format='%(refname:short)' --contains "$first_commit" \
        | grep -vx "$current" | grep -v '^backup/rebase/' || true)
    if [ -n "$children" ]; then
        warning "書き換え対象コミットを含む他ブランチあり（rebase 後に親子関係が切れる）:"
        echo "$children" | sed 's/^/  - /'
    else
        echo "(なし)"
    fi
else
    echo "(対象範囲なし)"
fi
echo ""

echo "=== WORKTREES ==="
wt_count=$(git worktree list | wc -l)
if [ "$wt_count" -gt 1 ]; then
    git worktree list
    echo "NOTE: 他 worktree のブランチが書き換え範囲と独立か確認すること"
else
    echo "(単一 worktree)"
fi
echo ""

echo "=== MERGE COMMITS IN RANGE ==="
merges=$(git rev-list --merges "$merge_base"..HEAD)
if [ -n "$merges" ]; then
    warning "範囲内にマージコミットあり。通常の rebase では平坦化されて消える（保持するなら --rebase-merges だが履歴構造が変わる。計画で扱いを明示すること）"
    git log --oneline --no-decorate --merges "$merge_base"..HEAD
else
    echo "(なし)"
fi
echo ""

echo "=== SIGNED COMMITS ==="
if [ "$range_count" -gt 0 ]; then
    signed=$(git log --format='%G?' "$merge_base"..HEAD 2>/dev/null | grep -cv '^N$' || true)
    if [ "${signed:-0}" -gt 0 ]; then
        gpgsign=$(git config --get commit.gpgsign || echo false)
        echo "NOTE: 署名付きコミット ${signed} 件。rebase で元の署名は失われる（commit.gpgsign=${gpgsign} の設定で再署名有無が決まる）"
    else
        echo "(署名付きコミットなし)"
    fi
else
    echo "(対象範囲なし)"
fi
echo ""

echo "=== GRAPH（親子関係） ==="
git log --graph --oneline --decorate --boundary HEAD "$base_sha" --not "$merge_base" | head -100 || true
echo ""

echo "=== CONFLICT PREDICTION ==="
if [ "$rtype" = "onto" ] && [ "$merge_tree_ok" = "yes" ]; then
    set +e
    mt_out=$(git merge-tree --write-tree --name-only "$base_sha" HEAD 2>&1)
    mt_rc=$?
    set -e
    if [ "$mt_rc" -eq 0 ]; then
        echo "コンフリクト予測: なし（一括マージ近似でクリーン）"
    elif [ "$mt_rc" -eq 1 ]; then
        echo "コンフリクト予測: あり — 以下のファイルで衝突見込み"
        echo "$mt_out" | tail -n +2
        echo ""
        echo "NOTE: merge-tree は一括マージの近似。rebase はコミットを 1 つずつ適用するため、途中コミットで別の衝突が出る/消える可能性がある"
    else
        echo "(merge-tree 実行エラー: $mt_out)"
    fi
elif [ "$rtype" = "history-edit" ]; then
    echo "(in-place 整理のため一括予測は対象外。pick の並べ替え・drop はコンフリクトを生む可能性あり — todo 承認時に考慮)"
else
    echo "(git < 2.38 のため予測不可)"
fi
echo ""

print_summary
