#!/usr/bin/env bash
# gh-ci-investigate.sh — GitHub Actions の失敗調査を gh 経由で決定論的に収集する。
#
# WebFetch は github.com を叩けない（cchook が差し戻す）うえ HTML を返すだけで
# ログにならない。失敗ジョブ・ステップと「失敗ステップのログだけ」は gh で確実に
# 取れるので、URL / run_id / PR 番号を渡された時点でこのスクリプトに解決させる。
#
# 使い方:
#   gh-ci-investigate.sh parse     <url|run_id|#PR|pr:PR>            解決結果(host/repo/run/job/pr)のみ出力
#   gh-ci-investigate.sh preflight  [url|run_id|#PR|pr:PR]          失敗ジョブ/ステップ/結論の要約（空=cwd repo の最新 run）
#   gh-ci-investigate.sh logs       [url|run_id|#PR|pr:PR] [--job <id>]   失敗ステップのログのみ
#
# 受理する入力:
#   https://HOST/OWNER/REPO/actions/runs/RUNID[/job/JOBID][/attempts/N][?pr=NN]
#   https://HOST/OWNER/REPO/pull/PRNUM[/checks]
#   RUNID          … 全桁数字。repo は cwd の remote から gh が解決
#   #PRNUM / pr:PRNUM … repo は cwd から解決
#   (空)           … cwd repo の最新 run
#
# 修正は一切行わない。収集だけ。GitHub(github.com / GitHub Enterprise)専用。
set -euo pipefail

die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

HOST=""; REPO=""; RUN_ID=""; JOB_ID=""; PR=""

# 入力を HOST/REPO/RUN_ID/JOB_ID/PR に正規化する。URL からは HOST と REPO も取れるが、
# 数字・#PR・空のときは REPO を空のままにして gh に cwd の remote を解決させる。
parse_input() {
  local in="${1:-}"
  [ -n "$in" ] || return 0
  case "$in" in
    http*://*)
      local rest path owner repo
      rest="${in#*://}"
      HOST="${rest%%/*}"
      path="${rest#*/}"
      path="${path%%\?*}"                 # ?pr= 等のクエリは落とす（run から辿れる）
      owner="${path%%/*}"; path="${path#*/}"
      repo="${path%%/*}";  path="${path#*/}"
      [ -n "$owner" ] && [ -n "$repo" ] || die "URL から OWNER/REPO を取れません: $in"
      REPO="$owner/$repo"
      case "/$path/" in
        */actions/runs/*)
          local after="${path#*actions/runs/}"
          RUN_ID="${after%%/*}"
          case "$path" in
            */job/*) JOB_ID="${path#*/job/}"; JOB_ID="${JOB_ID%%/*}" ;;
          esac
          ;;
        */pull/*) PR="${path#*pull/}"; PR="${PR%%/*}" ;;
        *) die "URL から actions run / pull を特定できません: $in" ;;
      esac
      ;;
    \#[0-9]*)  PR="${in#\#}" ;;
    pr:[0-9]*) PR="${in#pr:}" ;;
    [0-9]*)    RUN_ID="$in" ;;
    *) die "入力を解釈できません: $in（URL / run_id / #PR / 空 のいずれか）" ;;
  esac
}

cmd="${1:-preflight}"; shift || true
input=""
for a in "$@"; do
  case "$a" in
    --job) NEXT_IS_JOB=1 ;;
    -*) die "不明なオプション: $a" ;;
    *)
      if [ "${NEXT_IS_JOB:-0}" = 1 ]; then JOB_ID="$a"; NEXT_IS_JOB=0
      else input="$a"; fi
      ;;
  esac
done

command -v gh >/dev/null 2>&1 || die "gh が見つかりません。GitHub CLI を導入してください"
parse_input "$input"

# -R フラグ: URL 由来で REPO が取れたときだけ明示。無ければ gh が cwd の remote を使う。
RARGS=()
[ -n "$REPO" ] && RARGS=(-R "$HOST/$REPO")

# cwd 依存の解決には git リポジトリが要る。
need_cwd_repo() {
  [ -n "$REPO" ] && return 0
  git rev-parse --git-dir >/dev/null 2>&1 \
    || die "URL も run_id も無く、git リポジトリ外です。URL か run_id を指定してください。"
}

# PR → 失敗している check の run_id 群（重複排除）。bucket=="fail" が失敗系をまとめる。
pr_failed_run_ids() {
  gh pr checks "$PR" "${RARGS[@]}" --json bucket,link \
      --jq '.[] | select(.bucket=="fail") | .link' 2>/dev/null \
    | grep -oE 'runs/[0-9]+' | grep -oE '[0-9]+' | sort -u
}

# 空入力 → cwd repo の最新 run。
resolve_latest_run() {
  RUN_ID="$(gh run list -L 1 --json databaseId --jq '.[0].databaseId' 2>/dev/null || true)"
  [ -n "$RUN_ID" ] || die "最新の run を特定できません。URL か run_id を指定してください。"
}

run_summary() {   # $1 = run_id
  echo "--- run $1: 結論と失敗ジョブ/ステップ ---"
  gh run view "$1" "${RARGS[@]}" \
      --json displayTitle,status,conclusion,headBranch,event,workflowName,url \
      --jq '"title:     \(.displayTitle)\nworkflow:  \(.workflowName)\nbranch:    \(.headBranch)  event: \(.event)\nstatus:    \(.status)  conclusion: \(.conclusion)\nurl:       \(.url)"' \
    || { echo "  (run $1 のメタ取得に失敗。権限/hostname/認証を確認)"; return 0; }
  echo "  失敗ジョブ・ステップ:"
  gh run view "$1" "${RARGS[@]}" --json jobs \
      --jq '.jobs[] | select(.conclusion=="failure" or .conclusion=="cancelled" or .conclusion=="timed_out")
            | "  ✗ job: \(.name) [\(.conclusion)] (id: \(.databaseId))",
              (.steps[] | select(.conclusion=="failure" or .conclusion=="cancelled" or .conclusion=="timed_out")
               | "      step \(.number): \(.name) [\(.conclusion)]")' \
    || echo "  (ジョブ内訳を取得できませんでした)"
}

case "$cmd" in
  parse)
    [ -n "$input" ] || die "parse には入力が必要です"
    echo "=== RESOLVED ==="
    echo "host:    ${HOST:-(cwd remote)}"
    echo "repo:    ${REPO:-(cwd remote)}"
    echo "run_id:  ${RUN_ID:-(none)}"
    echo "job_id:  ${JOB_ID:-(none)}"
    echo "pr:      ${PR:-(none)}"
    ;;

  preflight)
    need_cwd_repo
    echo "=== TARGET ==="
    echo "host:   ${HOST:-(cwd remote)}"
    echo "repo:   ${REPO:-(cwd remote)}"
    echo
    echo "=== AUTH ==="
    if [ -n "$HOST" ]; then gh auth status --hostname "$HOST" 2>&1 | sed 's/^/  /' || true
    else gh auth status 2>&1 | sed 's/^/  /' || true; fi
    echo
    echo "=== FAILED CI ==="
    if [ -n "$PR" ]; then
      echo "PR #$PR の checks:"
      gh pr checks "$PR" "${RARGS[@]}" 2>&1 | sed 's/^/  /' || echo "  (pr checks 取得失敗)"
      echo
      local_ids="$(pr_failed_run_ids || true)"
      if [ -n "$local_ids" ]; then
        echo "失敗 check の run:"
        while read -r rid; do [ -n "$rid" ] && run_summary "$rid"; done <<< "$local_ids"
      else
        echo "  失敗している check の run_id を特定できませんでした。"
      fi
    else
      [ -n "$RUN_ID" ] || resolve_latest_run
      run_summary "$RUN_ID"
    fi
    echo
    echo "=== NEXT ==="
    echo "失敗ステップのログ取得:"
    if [ -n "$JOB_ID" ]; then
      echo "  bash <skill-dir>/scripts/gh-ci-investigate.sh logs '${input:-$RUN_ID}' --job $JOB_ID"
    else
      echo "  bash <skill-dir>/scripts/gh-ci-investigate.sh logs '${input:-$RUN_ID}'"
    fi
    ;;

  logs)
    need_cwd_repo
    if [ -n "$PR" ] && [ -z "$RUN_ID" ]; then
      RUN_ID="$(pr_failed_run_ids | head -n1 || true)"
      [ -n "$RUN_ID" ] || die "PR #$PR に失敗 run が見つかりません。preflight で確認してください。"
      echo "note: PR #$PR の失敗 run のうち先頭 ($RUN_ID) のログを表示します。複数あるときは preflight の一覧から run_id を直接指定してください。"
      echo
    fi
    [ -n "$RUN_ID" ] || resolve_latest_run
    echo "=== FAILED LOG (run $RUN_ID${JOB_ID:+, job $JOB_ID}) ==="
    # --log-failed は失敗ステップのログだけを返す（full log ではないので context に優しい）。
    # run が実行中だとログ未確定でエラーになるため、その場合は要約にフォールバックする。
    if [ -n "$JOB_ID" ]; then
      gh run view "$RUN_ID" --job "$JOB_ID" --log-failed "${RARGS[@]}" 2>/dev/null \
        || gh run view "$RUN_ID" --job "$JOB_ID" --log "${RARGS[@]}" 2>/dev/null \
        || { echo "(ログ未確定。run がまだ実行中か、権限不足の可能性。要約に戻ります)"; run_summary "$RUN_ID"; }
    else
      gh run view "$RUN_ID" --log-failed "${RARGS[@]}" 2>/dev/null \
        || { echo "(失敗ログを取得できませんでした。run がまだ実行中か、権限不足の可能性。要約に戻ります)"; run_summary "$RUN_ID"; }
    fi
    ;;

  *)
    die "未知のサブコマンド: $cmd （parse | preflight | logs）"
    ;;
esac
