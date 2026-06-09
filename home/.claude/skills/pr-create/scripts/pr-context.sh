#!/usr/bin/env bash
#
# pr-context.sh — 作業ブランチの「ベースブランチ（分岐元）」を特定し、
# PR 作成に必要なコミット差分情報をまとめて出力する。read-only。
#
# ベースブランチは「リモートリポジトリの既定ブランチ」ではなく、
# 現在の作業ブランチが分岐した元ブランチをローカルで探索して決める。
#
# Usage:
#   pr-context.sh [base-branch]
#     base-branch を渡すと探索せずそれをベースとして使う。
#
# 出力は `=== SECTION ===` 区切りのプレーンテキスト。呼び出し側（スキル）が
# これを読んでタイトル・本文を組み立てる。
set -euo pipefail

base_override="${1:-}"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "ERROR: git リポジトリ内で実行してください" >&2
    exit 1
fi

current=$(git rev-parse --abbrev-ref HEAD)
if [ "$current" = "HEAD" ]; then
    echo "ERROR: detached HEAD 状態です。ブランチをチェックアウトしてください" >&2
    exit 1
fi

# --- ベースブランチ探索 ---------------------------------------------------
# 候補ブランチそれぞれと HEAD の merge-base を取り、HEAD から merge-base まで
# のコミット数（= 分岐後の距離）が最小の候補を「直近の分岐元」とみなす。
# 距離が小さいほど近い枝分かれ。距離 0（差分なし）の候補は後回し。
detect_base() {
    if [ -n "$base_override" ]; then
        echo "$base_override"
        return
    fi

    local -a candidates=()
    # origin の既定ブランチ（origin/HEAD）があれば候補に加える
    local def
    if def=$(git symbolic-ref --quiet refs/remotes/origin/HEAD 2>/dev/null); then
        candidates+=("${def#refs/remotes/}")
    fi
    # よくあるベースブランチ名（ローカル / origin 両方）
    local b
    for b in main master develop development trunk; do
        git show-ref --verify --quiet "refs/heads/$b" && candidates+=("$b") || true
        git show-ref --verify --quiet "refs/remotes/origin/$b" && candidates+=("origin/$b") || true
    done

    local head_sha
    head_sha=$(git rev-parse HEAD)

    local c mb dist
    local best="" best_dist=-1          # 距離 > 0 の最小
    local zero_best=""                  # 距離 0 のフォールバック候補
    for c in "${candidates[@]}"; do
        # 現在のブランチ自身は除外（origin/<current> も）
        [ "$c" = "$current" ] && continue
        [ "$c" = "origin/$current" ] && continue
        mb=$(git merge-base "$c" HEAD 2>/dev/null) || continue
        if [ "$mb" = "$head_sha" ]; then
            # 候補が HEAD の子孫または同一。分岐元ではない
            continue
        fi
        dist=$(git rev-list --count "$mb"..HEAD)
        if [ "$dist" -eq 0 ]; then
            [ -z "$zero_best" ] && zero_best="$c"
            continue
        fi
        if [ "$best_dist" -lt 0 ] || [ "$dist" -lt "$best_dist" ]; then
            best_dist="$dist"
            best="$c"
        fi
    done

    if [ -n "$best" ]; then
        echo "$best"
    elif [ -n "$zero_best" ]; then
        echo "$zero_best"
    else
        echo ""   # 特定できず
    fi
}

# --- プラットフォーム判定 -------------------------------------------------
# remote URL のホストから github / gitlab / bitbucket を判定し、使用 CLI と
# その有無を出す。ホスト不明（GHE 等の self-hosted 含む）は unknown とし、
# CLI の有無を頼りに呼び出し側が判断する。
detect_platform() {
    local url host platform cli cli_found
    url=$(git remote get-url origin 2>/dev/null || git remote get-url "$(git remote | head -1)" 2>/dev/null || echo "")
    if [ -z "$url" ]; then
        echo "remote: (なし)"
        echo "platform: none"
        return
    fi
    # scheme:// と user@ を除去し、最初の : か / までをホストとして取る
    host=$(printf '%s' "$url" | sed -E 's#^[a-zA-Z]+://##; s#^[^@/]+@##; s#[:/].*$##')

    case "$host" in
        github.com|*.github.com)     platform=github;  cli=gh   ;;
        gitlab.com|*.gitlab.com)     platform=gitlab;  cli=glab ;;
        bitbucket.org)               platform=bitbucket; cli="" ;;
        *github*)                    platform=github;  cli=gh   ;;  # GHE 等
        *gitlab*)                    platform=gitlab;  cli=glab ;;  # self-hosted GitLab
        *)                           platform=unknown; cli=""   ;;
    esac

    echo "remote: $url"
    echo "host: $host"
    echo "platform: $platform"
    if [ -n "$cli" ]; then
        if command -v "$cli" >/dev/null 2>&1; then cli_found=yes; else cli_found=no; fi
        echo "cli: $cli (installed: $cli_found)"
    else
        echo "cli: (該当 CLI なし。手動作成へフォールバック)"
    fi
}

base=$(detect_base)

echo "=== CURRENT BRANCH ==="
echo "$current"
echo ""

echo "=== PLATFORM ==="
detect_platform
echo ""

echo "=== BASE BRANCH ==="
if [ -z "$base" ]; then
    echo "(特定できませんでした。ユーザーに確認してください)"
    echo ""
    echo "=== NOTE ==="
    echo "main / master / develop / origin/HEAD いずれとも分岐関係を特定できませんでした。"
    echo "ベースブランチを引数で明示して再実行してください: pr-context.sh <base-branch>"
    exit 0
fi
echo "$base"
if [ -n "$base_override" ]; then
    echo "(引数で明示指定)"
else
    echo "(分岐元として自動検出)"
fi
echo ""

mb=$(git merge-base "$base" HEAD)

echo "=== UPSTREAM / PUSH STATUS ==="
# 現ブランチの追跡先と ahead/behind。スキルは push 状態の判断に使う（push は代行しない）
if upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null); then
    echo "upstream: $upstream"
    counts=$(git rev-list --left-right --count "$upstream"...HEAD 2>/dev/null || echo "? ?")
    behind=$(echo "$counts" | awk '{print $1}')
    ahead=$(echo "$counts" | awk '{print $2}')
    echo "ahead: $ahead / behind: $behind"
    if [ "$ahead" != "0" ]; then
        echo "WARNING: ローカルに未 push のコミットが ${ahead} 件あります。push はユーザーが実施してください。"
    fi
else
    echo "upstream: (未設定 — リモート未 push)"
    echo "WARNING: このブランチはリモートに push されていません。PR 作成前にユーザーが push する必要があります。"
fi
echo ""

echo "=== COMMITS ($base..HEAD) ==="
git log "$base"..HEAD --oneline --no-decorate || true
echo ""

echo "=== COMMIT MESSAGES (full) ==="
# 本文素材。subject + body をコミットごとに出す
git log "$base"..HEAD --format='--- %h %s%n%b' || true
echo ""

echo "=== DIFF STAT ($base...HEAD) ==="
git diff "$base"...HEAD --stat || true
echo ""

echo "=== CHANGED FILES ==="
git diff "$base"...HEAD --name-status || true
echo ""

echo "=== NOTE ==="
echo "完全な差分が必要な場合: git diff ${base}...HEAD"
echo "merge-base: $mb"
