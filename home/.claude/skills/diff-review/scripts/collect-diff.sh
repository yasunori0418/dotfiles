#!/usr/bin/env bash
# diff-review: レビュー対象差分の決定論的収集(読み取り専用・stdout のみ)
#
# usage:
#   collect-diff.sh manifest [<base-ref>]                    範囲解決 + コミット一覧 + 統計(小径なら全文同梱)
#   collect-diff.sh commit <sha>                             単一コミットの diff(除外適用)
#   collect-diff.sh worktree                                 未コミット変更の diff(staged + unstaged)
#   collect-diff.sh cumulative [<base-ref>] [-- <path>...]   累積 diff(path 明示時は除外を適用しない)
set -euo pipefail

INLINE_THRESHOLD=300 # 累積 diff(除外分を除く)がこの行数以下なら manifest に全文を同梱

# lockfile・生成物: 全文は出力せず統計のみ(git pathspec、'*' はディレクトリ区切りもまたぐ)
EXCLUDE_PATTERNS=(
    '*.lock'
    '*.lockfile'
    '*package-lock.json'
    '*pnpm-lock.yaml'
    '*go.sum'
    '*.min.js'
    '*.min.css'
)
EXCLUDE_PATHSPEC=()
for p in "${EXCLUDE_PATTERNS[@]}"; do
    EXCLUDE_PATHSPEC+=(":(exclude)$p")
done

usage() {
    sed -n '2,8p' "$0" | cut -c3-
}

# BASE_REF / BASE_SHA を解決する。引数 > origin/HEAD > main / master の順
resolve_base() {
    local base_ref="${1:-}"
    if [[ -z "$base_ref" ]]; then
        base_ref=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null || true)
    fi
    if [[ -z "$base_ref" ]]; then
        local c
        for c in main master; do
            if git rev-parse --quiet --verify "refs/heads/$c" >/dev/null; then
                base_ref="$c"
                break
            fi
        done
    fi
    if [[ -z "$base_ref" ]]; then
        echo "ERROR: デフォルトブランチを特定できない。base-ref を引数で指定すること" >&2
        exit 1
    fi
    BASE_REF="$base_ref"
    BASE_SHA=$(git merge-base "$base_ref" HEAD)
}

# numstat をインデント付き "path +adds -dels" に整形する
format_numstat() {
    awk -F'\t' '{printf "  %s +%s -%s\n", $3, $1, $2}'
}

# numstat の総変更行数(バイナリ "-" は除く)
sum_numstat() {
    awk -F'\t' '{ if ($1 != "-") t += $1; if ($2 != "-") t += $2 } END { print t + 0 }'
}

cmd_manifest() {
    resolve_base "${1:-}"
    local head_sha branch commits untracked
    head_sha=$(git rev-parse HEAD)
    branch=$(git symbolic-ref --quiet --short HEAD || echo "(detached)")
    commits=$(git log --reverse --format='%h %s' "$BASE_SHA..HEAD")
    untracked=$(git ls-files --others --exclude-standard)

    if [[ -z "$commits" && -z "$untracked" ]] && git diff --quiet HEAD; then
        echo "NO_CHANGES"
        return
    fi

    echo "== RANGE =="
    echo "base_ref=$BASE_REF"
    echo "base=$BASE_SHA"
    echo "head=$head_sha (branch: $branch)"
    echo

    echo "== COMMITS (base..HEAD, 古い順) =="
    if [[ -z "$commits" ]]; then
        echo "(なし)"
    else
        local sha subject
        while read -r sha _; do
            subject=$(git log -1 --format='%s' "$sha")
            echo "- $sha $subject"
            git show --numstat --format= "$sha" -- . "${EXCLUDE_PATHSPEC[@]}" | format_numstat | sed 's/^/  /'
        done <<<"$commits"
    fi
    echo

    echo "== WORKTREE (未コミット変更: staged + unstaged) =="
    local worktree_stat
    worktree_stat=$(git diff --numstat HEAD -- . "${EXCLUDE_PATHSPEC[@]}")
    if [[ -z "$worktree_stat" ]]; then
        echo "(なし)"
    else
        format_numstat <<<"$worktree_stat"
    fi
    echo

    echo "== UNTRACKED (未追跡ファイル: Read ツールで参照する) =="
    if [[ -z "$untracked" ]]; then
        echo "(なし)"
    else
        local f
        while IFS= read -r f; do
            echo "  $f ($(wc -l <"$f") lines)"
        done <<<"$untracked"
    fi
    echo

    echo "== EXCLUDED (lockfile・生成物: 統計のみ、全文は取得不可) =="
    local excluded_stat
    excluded_stat=$(git diff --numstat "$BASE_SHA" -- "${EXCLUDE_PATTERNS[@]}")
    if [[ -z "$excluded_stat" ]]; then
        echo "(なし)"
    else
        format_numstat <<<"$excluded_stat"
    fi
    echo

    local total untracked_lines=0
    total=$(git diff --numstat "$BASE_SHA" -- . "${EXCLUDE_PATHSPEC[@]}" | sum_numstat)
    if [[ -n "$untracked" ]]; then
        local f
        while IFS= read -r f; do
            untracked_lines=$((untracked_lines + $(wc -l <"$f")))
        done <<<"$untracked"
    fi
    echo "== SIZE =="
    echo "total_changed_lines=$total (除外分を除く) + untracked_lines=$untracked_lines"
    echo

    if ((total <= INLINE_THRESHOLD)); then
        echo "== FULL DIFF (total <= ${INLINE_THRESHOLD} のため同梱。未追跡ファイルは含まない) =="
        git diff "$BASE_SHA" -- . "${EXCLUDE_PATHSPEC[@]}"
    else
        echo "== FULL DIFF 省略 (total > ${INLINE_THRESHOLD}) =="
        echo "commit <sha> / worktree / cumulative [-- <path>...] で必要な単位のみ取得すること"
    fi
}

cmd_commit() {
    local sha="${1:-}"
    if [[ -z "$sha" ]]; then
        echo "ERROR: commit <sha> の形式で指定すること" >&2
        exit 1
    fi
    git show "$sha" -- . "${EXCLUDE_PATHSPEC[@]}"
}

cmd_worktree() {
    git diff HEAD -- . "${EXCLUDE_PATHSPEC[@]}"
    local untracked
    untracked=$(git ls-files --others --exclude-standard)
    if [[ -n "$untracked" ]]; then
        echo
        echo "== UNTRACKED (Read ツールで参照する) =="
        local f
        while IFS= read -r f; do
            echo "  $f"
        done <<<"$untracked"
    fi
}

cmd_cumulative() {
    local base_arg="" paths=()
    while (($#)); do
        case "$1" in
            --)
                shift
                paths=("$@")
                break
                ;;
            *)
                base_arg="$1"
                shift
                ;;
        esac
    done
    resolve_base "$base_arg"
    if ((${#paths[@]})); then
        git diff "$BASE_SHA" -- "${paths[@]}"
    else
        git diff "$BASE_SHA" -- . "${EXCLUDE_PATHSPEC[@]}"
    fi
}

sub="${1:-}"
if (($#)); then shift; fi
case "$sub" in
    manifest) cmd_manifest "$@" ;;
    commit) cmd_commit "$@" ;;
    worktree) cmd_worktree ;;
    cumulative) cmd_cumulative "$@" ;;
    *)
        usage >&2
        exit 1
        ;;
esac
