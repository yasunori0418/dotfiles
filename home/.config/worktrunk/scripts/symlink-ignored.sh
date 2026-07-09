#!/usr/bin/env bash
# worktree 内の gitignored 物を、メインworktreeへの symlink に置き換える。
# 既に実体コピーされているファイル（wt step copy-ignored 経由）は触らない。
#
# Usage: symlink-ignored.sh <primary-worktree-path>
set -euo pipefail

primary="${1:?primary worktree path required as first argument}"

# symlink 化しない対象パターン (basename に対する glob)
# 注意: .gitignore がディレクトリ専用パターン (例: "build/") の場合、symlinkは
#       ファイル扱いになりignore判定されずuntracked化する。該当ディレクトリは
#       ここで除外して symlink を作らないようにする。
#
# 判定はパス自身および祖先の basename に対して行うので、"build" を入れれば
# "build", "loglass-api/build", "loglass-api/build/foo" 全部スキップされる。
#
# プロジェクト固有のスキップパターンは、メインworktree直下の .worktreeskip に
# 1行1パターンで記述する (個人用ファイル / global gitignoreで除外)。
SKIP_PATTERNS=(
    # 環境系
    #   .direnv / .devenv  : flake変更時にメインworktreeの環境を壊さないため
    #   .env / .envrc      : ブランチごとに変更可能 + 共有事故を避けるため
    #   *.zwc              : zshソース変更時に古いバイトコードを参照しないため
    ".direnv"
    ".devenv"
    ".env"
    ".envrc"
    "*.zwc"

    # こういう環境依存みたいなの消したい
    ".DS_Store"

    # worktrunk 制御ファイル (メインworktreeからのみ読むので worktree には不要)
    ".worktreesetup"

    # Gradle / JVM
    "build"
    ".gradle"
    ".kotlin"

    # Node.js
    "node_modules"
    ".next"

    # Python
    "__pycache__"
    ".venv"
    ".pytest_cache"
    ".ruff_cache"

    # AI関連 (プロジェクト内設定は worktree ごとに独立、共有しない)
    ".claude"

    # その他のビルド/キャッシュ/出力 (汎用ツール由来)
    ".husky"
    "nohup.out"
)

# プロジェクト固有パターンを <primary>/.worktreeskip から追加
project_skip_file="$primary/.worktreeskip"
if [ -f "$project_skip_file" ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        case "$line" in
            '#'* | '') continue ;;
        esac
        SKIP_PATTERNS+=("$line")
    done < "$project_skip_file"
fi

# パス自身、または祖先のいずれかの basename が SKIP_PATTERNS にマッチするか
should_skip() {
    local p="$1" base pattern
    while [ -n "$p" ] && [ "$p" != "." ] && [ "$p" != "/" ]; do
        base="$(basename "$p")"
        for pattern in "${SKIP_PATTERNS[@]}"; do
            # shellcheck disable=SC2254  # case パターンとしてglob展開させるため
            case "$base" in
                $pattern) return 0 ;;
            esac
        done
        p="$(dirname "$p")"
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
