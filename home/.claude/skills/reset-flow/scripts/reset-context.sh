#!/usr/bin/env bash
#
# reset-context.sh — git reset 計画に必要な情報とガードレール判定材料を
# まとめて出力する。read-only。
#
# Usage:
#   reset-context.sh <target-ref> <hard|mixed|soft>
#     target-ref: reset 先（例: backup/rebase/..., HEAD~1, origin/main, SHA）
#     mode:       実行予定の reset モード（失われるものの判定に使う）
#
# 出力は `=== SECTION ===` 区切り。
#   BLOCKER: が 1 行でもあれば reset 計画に進んではならない。
#   WARNING: は全て計画に明記して承認対象に含める。
set -euo pipefail

if [ $# -lt 2 ]; then
    echo "Usage: reset-context.sh <target-ref> <hard|mixed|soft>" >&2
    exit 1
fi
target_ref="$1"
mode="$2"
case "$mode" in
    hard | mixed | soft) ;;
    *)
        echo "ERROR: mode は hard | mixed | soft のいずれか（指定: $mode）" >&2
        exit 1
        ;;
esac

blockers=0
warnings=0
blocker() { echo "BLOCKER: $*"; blockers=$((blockers + 1)); }
warning() { echo "WARNING: $*"; warnings=$((warnings + 1)); }

print_summary() {
    echo "=== SUMMARY ==="
    echo "blockers: $blockers / warnings: $warnings"
    if [ "$blockers" -gt 0 ]; then
        echo "判定: BLOCKER あり — reset 計画に進まないこと"
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
    blocker "保護ブランチ ($current — $preason) 上での reset は禁止。作業ブランチでのみ実行可"
fi
echo ""

echo "=== IN-PROGRESS OPERATIONS ==="
op_found=no
for p in rebase-merge rebase-apply MERGE_HEAD CHERRY_PICK_HEAD REVERT_HEAD BISECT_LOG; do
    if [ -e "$(git rev-parse --git-path "$p")" ]; then
        blocker "進行中の操作あり: $p（reset で潰さず、--abort / --continue で終わらせること）"
        op_found=yes
    fi
done
[ "$op_found" = no ] && echo "(なし)"
echo ""

echo "=== TARGET ==="
if ! target_sha=$(git rev-parse --verify --quiet "${target_ref}^{commit}"); then
    echo "ERROR: target-ref '$target_ref' を解決できません" >&2
    exit 1
fi
head_sha=$(git rev-parse HEAD)
echo "target-ref: $target_ref ($target_sha)"
echo "mode: --$mode"
if [ "$target_sha" = "$head_sha" ]; then
    rel="same"
elif git merge-base --is-ancestor "$target_sha" HEAD; then
    rel="ancestor"
elif git merge-base --is-ancestor HEAD "$target_sha"; then
    rel="descendant"
else
    rel="divergent"
fi
case "$rel" in
    same)
        echo "relationship: HEAD と同一"
        [ "$mode" != "hard" ] && blocker "HEAD と同一への --$mode reset は何もしない（指定誤りの可能性）"
        ;;
    ancestor) echo "relationship: HEAD の祖先（コミットを巻き戻す）" ;;
    descendant) echo "relationship: HEAD の子孫（前進 — 巻き戻しではない）" ;;
    divergent)
        echo "relationship: 分岐（共通祖先: $(git merge-base "$target_sha" HEAD)）"
        warning "target は HEAD と分岐している。現在の枝のコミットを離れて別の枝へ乗り換える reset になる"
        ;;
esac
echo ""

echo "=== COMMITS LEAVING BRANCH（ブランチから外れるコミット） ==="
leaving=$(git rev-list --count "$target_sha"..HEAD)
echo "count: $leaving"
if [ "$leaving" -gt 0 ]; then
    git log --oneline --no-decorate "$target_sha"..HEAD | head -50 || true
    echo ""
    echo "NOTE: これらは branch から到達不能になる（reflog と safety branch には残る）"
    if upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null); then
        pushed=$((leaving - $(git rev-list --count "$target_sha"..HEAD --not "$upstream")))
        if [ "$pushed" -gt 0 ]; then
            warning "外れるコミットのうち ${pushed} 件は push 済み。reset 後はリモートと分岐し、リモート反映には force-push が必要（rebase-flow §7 と同じ手順）"
        fi
    fi
else
    echo "(なし — コミットは失われない)"
fi
echo ""

echo "=== WORKING TREE ==="
dirty=$(git status --porcelain --untracked-files=no | wc -l)
if [ "$dirty" -gt 0 ]; then
    if [ "$mode" = "hard" ]; then
        warning "--hard は未コミット変更 ${dirty} ファイルを完全に消す。コミットにも reflog にも残らず復旧不能。破棄が意図なら計画にファイル一覧を明記し、arm 時に --allow-dirty を付ける"
        git status --short --untracked-files=no | head -20 || true
    else
        echo "未コミット変更 ${dirty} ファイルあり（--$mode では保持される。mixed は unstage される）"
    fi
else
    echo "clean"
fi
echo "untracked: $(git ls-files --others --exclude-standard | wc -l) 件（reset では消えない）"
echo "stash: $(git stash list | wc -l) 件"
echo ""

echo "=== UPSTREAM ==="
if upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null); then
    echo "upstream: $upstream ($(git rev-parse "$upstream"))"
else
    echo "upstream: (未設定)"
fi
echo ""

print_summary
