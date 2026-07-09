#!/usr/bin/env bash
# プロジェクト固有のセットアップを新worktreeで実行する。
# メインworktree直下に個人用スクリプト .worktreesetup があればそれを実行し、
# 無ければ何もしない。
#
# Usage: project-setup.sh <primary-worktree-path>
#   $1  = メインworktreeパス (config の {{ primary_worktree_path }})
#   cwd = 新worktreeルート (post-start フックの実行ディレクトリ)
#
# 実行される .worktreesetup には $1 としてメインworktreeパスを渡す。
# .worktreesetup は global gitignore で無視される個人用ファイルなので、
# リポジトリ毎に中身を変えられ、git・チームには影響しない。
set -euo pipefail

primary="${1:?primary worktree path required as first argument}"

setup_file="$primary/.worktreesetup"
[ -f "$setup_file" ] || exit 0

# cwd は新worktree。.worktreesetup にメインworktreeパスを引数で渡す。
exec bash "$setup_file" "$primary"
