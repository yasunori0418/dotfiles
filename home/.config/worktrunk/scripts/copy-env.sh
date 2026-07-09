#!/usr/bin/env bash
# .worktreeinclude の配置忘れに備えたフォールバック:
# メインworktreeに .env / .envrc があれば、新worktreeへ実体コピーする。
# .env / .envrc は symlink-ignored の SKIP 対象で symlink されないため、
# 実体コピーで各worktreeに独立した env を持たせる。
#
# Usage: copy-env.sh <primary-worktree-path>
#   $1  = メインworktreeパス (config の {{ primary_worktree_path }})
#   cwd = 新worktreeルート (pre-start フックの実行ディレクトリ)
#
# コピーは「メインに在り、かつ新worktreeにまだ無い時だけ」行う。
# 追跡ファイルとして checkout 済み等で既に在る場合は上書きしない
# (ブランチ固有の変更を壊さないため)。
set -euo pipefail

primary="${1:?primary worktree path required as first argument}"

for f in .env .envrc; do
    src="$primary/$f"
    if [ -f "$src" ] && [ ! -e "$f" ]; then
        cp "$src" "$f"
    fi
done
