#!/usr/bin/env bash
# worktree 内の gitignored 物を、メインworktreeへの symlink に置き換える。
# 既に実体コピーされているファイル（wt step copy-ignored 経由）は触らない。
#
# Usage: symlink-ignored.sh <primary-worktree-path>
set -euo pipefail

primary="${1:?primary worktree path required as first argument}"

# symlink 化しない対象パターン (glob)
#   .direnv / .devenv  : flake変更時にメインworktreeの環境を壊さないため
#   .env / .envrc      : ブランチごとに変更可能 + 共有事故を避けるため
#   *.zwc              : zshソース変更時に古いバイトコードを参照しないため
SKIP_PATTERNS=(
    ".direnv"
    ".direnv/*"
    ".devenv"
    ".devenv/*"
    ".env"
    ".envrc"
    "*.zwc"
)

should_skip() {
    local pattern
    for pattern in "${SKIP_PATTERNS[@]}"; do
        # shellcheck disable=SC2254  # case パターンとしてglob展開させるため
        case "$1" in
            $pattern) return 0 ;;
        esac
    done
    return 1
}

# 親パスのいずれかが symlink になっているか
ancestor_is_symlink() {
    local p
    p="$(dirname "$1")"
    while [ "$p" != "." ] && [ "$p" != "/" ]; do
        [ -L "$p" ] && return 0
        p="$(dirname "$p")"
    done
    return 1
}

git -C "$primary" ls-files --others --ignored --exclude-standard --directory | while IFS= read -r f; do
    dst="${f%/}"
    [ -z "$dst" ] && continue
    should_skip "$dst" && continue
    ancestor_is_symlink "$dst" && continue
    [ -L "$dst" ] && rm -f "$dst"
    if [ -e "$dst" ]; then
        echo "[symlink-ignored] skip: $dst already exists as non-symlink" >&2
        continue
    fi
    mkdir -p "$(dirname "$dst")"
    ln -sfn "$primary/$f" "$dst"
done
