#!/usr/bin/env bash
# gh-push.sh — 非対話セッション向け、HTTPS + gh トークン経由の git push。
#
# remote が SSH URL（git@github.com:owner/repo.git）でも、push 認証を
# gh の credential helper に肩代わりさせて HTTPS で実行する。秘密鍵の
# パスフレーズ入力（= 標準入力）を一切必要としないのが狙い。
#
# 使い方:
#   gh-push.sh preflight [branch]            push 対象を収集して提示用に出力（push しない）
#   gh-push.sh push      [branch] [--force]  実際に push する（--force は --force-with-lease）
#
# branch 省略時は現在のブランチ。force は push が non-fast-forward で
# 弾かれたときに、明示確認の上でのみ付ける。
set -euo pipefail

# 既存の credential.helper 一覧を空でリセットしてから gh ヘルパーだけを使う。
# cache / oauth など他ヘルパーの介入・キャッシュ汚染を避ける。
CRED_RESET=(-c credential.helper= -c credential.helper='!gh auth git-credential')

die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

# remote URL → "https_url<TAB>host" に正規化。
to_https() {
  local url="$1" host path rest
  case "$url" in
    https://*)
      rest="${url#https://}"
      rest="${rest#*@}"                 # 埋め込み認証情報があれば落とす
      host="${rest%%/*}"
      printf 'https://%s\t%s\n' "$rest" "$host"
      ;;
    ssh://*)
      rest="${url#ssh://}"
      rest="${rest#*@}"                 # user@ を落とす
      host="${rest%%/*}"
      host="${host%%:*}"                # :port を落とす
      path="${rest#*/}"
      printf 'https://%s/%s\t%s\n' "$host" "$path" "$host"
      ;;
    *@*:*)
      host="${url%%:*}"; host="${host#*@}"   # scp 形式 git@host:owner/repo.git
      path="${url#*:}"
      printf 'https://%s/%s\t%s\n' "$host" "$path" "$host"
      ;;
    *)
      die "未対応の remote URL です: $url"
      ;;
  esac
}

cmd="${1:-preflight}"; shift || true
force=0; branch=""
for a in "$@"; do
  case "$a" in
    --force|--force-with-lease) force=1 ;;
    -*) die "不明なオプション: $a" ;;
    *)  branch="$a" ;;
  esac
done

git rev-parse --git-dir >/dev/null 2>&1 || die "git リポジトリ内ではありません"

[ -n "$branch" ] || branch="$(git rev-parse --abbrev-ref HEAD)"
[ "$branch" != "HEAD" ] || die "detached HEAD です。push 先ブランチ名を引数で指定してください"

remote="$(git config "branch.$branch.remote" 2>/dev/null || echo origin)"
url="$(git remote get-url "$remote" 2>/dev/null || true)"
[ -n "$url" ] || die "remote '$remote' が見つかりません"

IFS=$'\t' read -r https host < <(to_https "$url")

command -v gh >/dev/null 2>&1 || die "gh が見つかりません。GitHub CLI を導入してください"
gh auth status --hostname "$host" >/dev/null 2>&1 \
  || die "gh が host '$host' で未認証です。'gh auth login --hostname $host' を実行してください"

local_tip="$(git rev-parse HEAD)"

# リモート側 tip を ls-remote で取得（gh トークン認証経由）。auth/URL の早期検証も兼ねる。
remote_tip="$(git "${CRED_RESET[@]}" ls-remote "$https" "refs/heads/$branch" 2>/dev/null | awk 'NR==1{print $1}')" || true

state="new"; need_force=0; range=""
if [ -n "$remote_tip" ]; then
  if [ "$remote_tip" = "$local_tip" ]; then
    state="up-to-date"
  elif git cat-file -e "${remote_tip}^{commit}" 2>/dev/null; then
    if git merge-base --is-ancestor "$remote_tip" "$local_tip" 2>/dev/null; then
      state="fast-forward"; range="${remote_tip}..${local_tip}"
    else
      state="diverged"; need_force=1
    fi
  else
    state="unknown"   # リモート tip がローカルに無く、FF 判定不能（push 時にサーバが検査）
  fi
fi

fopt=""; [ "$force" = 1 ] && fopt=" --force-with-lease"
push_cmd="git -c credential.helper= -c credential.helper='!gh auth git-credential' push${fopt} $https $branch"

case "$cmd" in
  preflight)
    echo "=== TARGET ==="
    echo "remote:     $remote"
    echo "remote_url: $url"
    echo "push_url:   $https"
    echo "host:       $host"
    echo "branch:     $branch"
    echo
    echo "=== AUTH ==="
    gh auth status --hostname "$host" 2>&1 | sed 's/^/  /'
    echo
    echo "=== STATE ==="
    echo "local HEAD:   $(git log -1 --format='%h %s' "$local_tip")"
    echo "remote state: $state"
    case "$state" in
      up-to-date) echo "(push 不要: リモートと一致)" ;;
      new)        echo "commits to push (新規ブランチ, 直近5件):"
                  git log -5 --format='  %h %s' "$local_tip" ;;
      fast-forward)
                  echo "commits to push:"
                  git log --format='  %h %s' "$range" ;;
      diverged)   echo "  リモートと履歴が分岐。通常 push は弾かれます。"
                  echo "  整合させる（fetch + rebase/merge）か、意図的な上書きなら --force が必要。" ;;
      unknown)    echo "  リモート tip ($remote_tip) がローカルに無く push 範囲を厳密判定できません。"
                  echo "  非 fast-forward ならサーバが push を拒否します（安全）。直近5件:"
                  git log -5 --format='  %h %s' "$local_tip" ;;
    esac
    echo
    echo "=== PUSH COMMAND ==="
    echo "$push_cmd"
    echo
    echo "=== WARNINGS ==="
    if [ "$need_force" = 1 ]; then
      echo "WARNING: 履歴分岐を検出。--force 無しの push は失敗します。ユーザー確認なしに force しないこと。"
    elif [ "$state" = "up-to-date" ]; then
      echo "WARNING: push する差分がありません。"
    else
      echo "(none)"
    fi
    ;;

  push)
    [ "$state" != "up-to-date" ] || { echo "push 不要: リモートと一致しています。"; exit 0; }
    if [ "$need_force" = 1 ] && [ "$force" != 1 ]; then
      die "履歴が分岐しています。--force_with_lease を意図する場合のみ push ... --force を再実行してください（要ユーザー確認）"
    fi
    set +e
    if [ "$force" = 1 ]; then
      git "${CRED_RESET[@]}" push --force-with-lease "$https" "$branch"
    else
      git "${CRED_RESET[@]}" push "$https" "$branch"
    fi
    rc=$?
    set -e
    [ "$rc" = 0 ] || die "push に失敗しました (exit $rc)"
    # URL 直 push だと remote-tracking ref が更新されないため、status 整合のため手で進める。
    git update-ref "refs/remotes/$remote/$branch" "$local_tip" 2>/dev/null || true
    echo "OK: $https $branch を更新しました ($(git log -1 --format='%h %s' "$local_tip"))"
    ;;

  *)
    die "未知のサブコマンド: $cmd （preflight | push）"
    ;;
esac
