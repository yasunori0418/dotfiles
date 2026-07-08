#!/usr/bin/env bash
# nix-cache-check.sh — Nix パッケージがバイナリキャッシュから来ずローカルビルドになる
# 原因を調査するための決定論的な下請け処理。
#
# 「バイナリキャッシュに無い」の原因は主に3系統に分かれる:
#   1. 実は substituters に該当パスが無い（cache-check で直接確認できる）
#   2. Hydra 側でまだビルドが完了/成功していない（hydra / build-json で確認）
#   3. 手元の flake が評価する derivation が、期待している修正を含んでいない
#      （outpath で実際の出力パスを確認、pr-ancestry で修正の取り込み有無を確認）
#
# 使い方:
#   nix-cache-check.sh outpath <flake-installable>
#       例: nix-cache-check.sh outpath '.#nixosConfigurations.myhost.pkgs.mise'
#       flake attr の drvPath / outPath を評価して表示する。
#       同じバージョン文字列でも依存更新で derivation ハッシュ（出力パス）が
#       変わることがあるため、cache-check や hydra で比較する前に必ずこれで
#       「今ロックしている flake が実際に指す出力パス」を確定させる。
#
#   nix-cache-check.sh cache-check <store-path-or-hash> [substituter...]
#       指定した出力パス（または先頭ハッシュ）が、設定済み substituters
#       （cache.nixos.org・各種 cachix 等）それぞれに存在するか narinfo を
#       直接 HTTP で叩いて確認する。substituter を省略すると
#       `nix show-config` から自動で全件拾う。
#
#   nix-cache-check.sh hydra <package> [hydra-check の追加引数...]
#       nix-community/hydra-check（pkgs.hydra-check）経由でビルド履歴一覧を見る。
#       例: nix-cache-check.sh hydra mise --channel nixpkgs-unstable --arch x86_64-linux
#       HTML を自前でスクレイピングするより先にまずこれを使う。
#
#   nix-cache-check.sh build-json <hydra-build-id>
#       個別ビルドの詳細を Hydra の JSON API（Accept: application/json）から取得する。
#       一覧ページのステータスバッジは簡易表示で不正確なことがあるため、
#       正確な成否（buildstatus/finished）はここで確認する。
#       失敗ログの中身は JSON に含まれないため、原因調査には build-log を使う。
#
#   nix-cache-check.sh build-log <hydra-build-id>
#       個別ビルドの HTML から失敗ステップのログ末尾を抜き出す。
#
#   nix-cache-check.sh pr-ancestry <owner/repo> <base-sha-or-tag> <head-sha>
#       base（例: PR の merge commit）が head（例: flake.lock がロックしている rev）
#       の祖先に含まれるかを GitHub compare API で確認する。nixpkgs 等の巨大リポジトリを
#       フルクローンせずに済む。behind_by が 0 なら「base は取り込み済み」。
#
# 前提: nix（flakes 有効）, curl, jq, gh（pr-ancestry のみ authが要る）
# build-log は Python スクリプトを uv 経由で実行する（PEP 723 inline metadata で
# Python バージョンを固定し再現性を持たせるため）。uv が無い環境でも nix さえ
# あれば `nix run nixpkgs#uv` で uv 自体を都度取得して同じ再現性を得られる。
set -euo pipefail

die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

# uv があれば uv run で実行し、無ければ nix 経由で uv を取得して実行する。
# どちらも無ければ諦める（生の python3 にフォールバックしない＝再現性を優先）。
run_py() {
    local script="$1"; shift
    if command -v uv >/dev/null 2>&1; then
        uv run "$script" "$@"
    elif command -v nix >/dev/null 2>&1; then
        nix run nixpkgs#uv -- run "$script" "$@"
    else
        die "uv も nix も見つかりません。https://docs.astral.sh/uv/ を導入するか nix をインストールしてください"
    fi
}

cmd="${1:-}"; shift || true

case "$cmd" in
    outpath)
        ref="${1:?flake installable を指定してください（例: '.#packages.x86_64-linux.hello'）}"
        echo "=== drvPath ==="
        nix eval --raw "${ref}.drvPath"
        echo
        echo "=== outPath ==="
        nix eval --raw "${ref}.outPath"
        ;;

    cache-check)
        target="${1:?store path または先頭ハッシュを指定してください}"; shift || true
        case "$target" in
            /nix/store/*) hash="$(basename "$target" | cut -d- -f1)" ;;
            *)            hash="$target" ;;
        esac

        subs=("$@")
        if [ "${#subs[@]}" -eq 0 ]; then
            mapfile -t subs < <(nix show-config --json 2>/dev/null | jq -r '.substituters.value[]')
        fi
        [ "${#subs[@]}" -gt 0 ] || die "substituters を取得できませんでした（nix show-config を確認してください）"

        echo "=== cache check: ${hash} ==="
        for sub in "${subs[@]}"; do
            url="${sub%/}/${hash}.narinfo"
            code="$(curl -s -o /dev/null -w '%{http_code}' "$url")"
            case "$code" in
                200) echo "HIT              $sub" ;;
                404) echo "MISS             $sub" ;;
                401|403) echo "NO_ACCESS($code)  $sub  # private cache の可能性。認証が要るかも" ;;
                *) echo "UNKNOWN($code)      $sub" ;;
            esac
        done
        ;;

    hydra)
        pkg="${1:?パッケージ名を指定してください}"; shift || true
        command -v hydra-check >/dev/null 2>&1 \
            && hydra-check "$pkg" "$@" \
            || nix run nixpkgs#hydra-check -- "$pkg" "$@"
        ;;

    build-json)
        id="${1:?Hydra build ID を指定してください}"
        curl -s -H 'Accept: application/json' "https://hydra.nixos.org/build/${id}" \
            | jq '{id, job, system, finished, buildstatus, drvpath, buildoutputs, starttime, stoptime}'
        ;;

    build-log)
        id="${1:?Hydra build ID を指定してください}"
        run_py "$(dirname "$0")/hydra_build_log.py" "$id"
        ;;

    pr-ancestry)
        repo="${1:?owner/repo を指定してください}"
        base="${2:?base（例: PRのmerge commit sha）を指定してください}"
        head="${3:?head（例: flake.lock がロックしている rev）を指定してください}"
        command -v gh >/dev/null 2>&1 || die "gh が見つかりません"
        gh api "repos/${repo}/compare/${base}...${head}" --jq '{status, ahead_by, behind_by}'
        echo "# behind_by が 0 なら base は head の祖先＝取り込み済み"
        ;;

    *)
        die "未知のサブコマンド: '$cmd'（outpath | cache-check | hydra | build-json | build-log | pr-ancestry）"
        ;;
esac
