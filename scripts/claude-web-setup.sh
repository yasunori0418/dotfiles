#!/usr/bin/env bash

# Claude Code on the web のセッションへ、この dotfiles を起点にした開発環境を用意する。
#
#   1. Nix を multi-user レイアウトでインストール（NixOS/nix-installer）
#   2. nix-daemon を起動（systemd が無いので自前で上げる）
#   3. homeConfigurations.claude-web の activationPackage をビルドして activate
#      （github の archive が塞がれている場合は input を git 経由で事前投入する）
#
# コンテナは毎セッション作り直されるため、セッション開始ごとに 1 回流す想定。環境の
# setup script へ登録しておくと Claude Code の起動前に走るので、配置した
# ~/.claude/settings.json の hook もそのセッションから有効になる。
#
# 前提:
#   - root で実行すること（--init none の Nix は root 専用になる）。

set -euo pipefail

readonly NIX_INSTALLER_URL="https://artifacts.nixos.org/nix-installer"
readonly NIX_PROFILE_DIR="/nix/var/nix/profiles/default"
readonly DAEMON_SOCKET="/nix/var/nix/daemon-socket/socket"

DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
readonly DOTFILES_DIR

# claude-web の egress は policy proxy を通る。CA を明示しないと Nix の fetch が
# 証明書検証で落ちる。proxy の無い環境では単に存在しないパスとして無視される。
readonly CCR_CA_BUNDLE="/root/.ccr/ca-bundle.crt"

log() { printf '\033[1;32m==>\033[0m %s\n' "$1"; }

install_nix() {
    if [[ -x ${NIX_PROFILE_DIR}/bin/nix ]]; then
        log "Nix は導入済み: $("${NIX_PROFILE_DIR}/bin/nix" --version)"
        return
    fi

    log "Nix をインストールする（multi-user / --init none）"
    local extra_conf=()
    if [[ -f ${CCR_CA_BUNDLE} ]]; then
        extra_conf+=(--extra-conf "ssl-cert-file = ${CCR_CA_BUNDLE}")
    fi

    # systemd が無いので --init none。daemon は下の start_daemon が起動する。
    # インストーラ末尾の self-test は daemon 未起動のため WARN を出すが無害。
    curl -sSfL "${NIX_INSTALLER_URL}" \
        | sh -s -- install linux --init none --no-confirm "${extra_conf[@]}"

    # インストーラが有効化するのは nix-command のみ。flakes は自前で足す。
    printf 'extra-experimental-features = flakes\n' >>/etc/nix/nix.custom.conf
}

# socket ファイルは daemon が死んでも残る。存在確認だけで「起動済み」と判断すると、
# 死んだ daemon を掴んだまま先へ進んでビルドが
# `cannot connect to socket ...: Connection refused` で落ちる。実際に応答するかで見る。
daemon_is_alive() {
    [[ -S ${DAEMON_SOCKET} ]] || return 1
    "${NIX_PROFILE_DIR}/bin/nix" store info --store daemon >/dev/null 2>&1
}

start_daemon() {
    if daemon_is_alive; then
        log "nix-daemon は起動済み"
        return
    fi

    # 死んだ daemon が残した socket は bind の邪魔になるので先に落とす。
    rm -f "${DAEMON_SOCKET}"

    log "nix-daemon を起動する"
    # daemon が substituter を引くので proxy / CA を明示的に渡す。呼び出し元のシェルが
    # 終わっても生き残るよう setsid で切り離す。
    # NIX_REMOTE は必ず外す。main が export した daemon を daemon 自身が受け取ると、
    # fork したワーカーが自分の socket へ繋ぎ直そうとして即死し、クライアント側は
    # `read of 32768 bytes: Connection reset by peer` で落ちる。
    # NOTE: proxy の待受ポートはセッション途中で変わることがある。cache.nixos.org へ
    #       繋がらなくなったら daemon を kill して本スクリプトを再実行すること
    #       （daemon は起動時の proxy 設定を握り続ける）。
    setsid nohup env -u NIX_REMOTE \
        HTTPS_PROXY="${HTTPS_PROXY:-}" https_proxy="${https_proxy:-}" \
        NIX_SSL_CERT_FILE="${NIX_SSL_CERT_FILE:-}" \
        "${NIX_PROFILE_DIR}/bin/nix-daemon" >/tmp/nix-daemon.log 2>&1 </dev/null &

    for _ in $(seq 1 30); do
        daemon_is_alive && return
        sleep 1
    done

    echo "nix-daemon が応答しない: /tmp/nix-daemon.log を確認すること" >&2
    exit 1
}

# claude-web の GitHub proxy は、セッションに紐づいていない repo の archive tarball と
# API を 403 にする。これは環境の network access level と独立していて、Full にしても
# 変わらない。flake の input は `github:` スキーム＝ archive 経由なので、素の
# `nix build` は入力解決の時点で必ず止まる。
#
# 一方 git smart-HTTP には同じ制限がかかっていない。`github:` の tarball を展開した
# tree と git が返す tree は NAR が一致する（＝ store path が同じ）ため、git 経由で
# 取って store へ入れておけば、入力解決は archive を叩かずに valid path を見つける。
#
# flake.lock から narHash を引き、fixed-output と同じ算出で store path を求めて、
# git 由来の path と突き合わせる。一致しなければ tree が tarball と異なる
# （export-ignore / submodule 等）ということなので、黙って進めず失敗させる。
readonly MAX_PRIME_ROUNDS=60

# nix の式へ値を渡す手段が無いので getEnv で受け渡す（式側の quote を素直に保つ）。
nix_eval_str() {
    "${NIX_PROFILE_DIR}/bin/nix" eval --raw --impure --expr "$1"
}

# 突き合わせは完全一致でよい。403 の URL は flake.lock の owner / repo から
# そのまま組み立てられるため、lock 側の表記と必ず一致する。
narhash_of() {
    SLUG="$1" REV="$2" LOCK_FILE="${DOTFILES_DIR}/flake.lock" nix_eval_str '
      let
        lock = builtins.fromJSON (builtins.readFile (builtins.getEnv "LOCK_FILE"));
        slug = builtins.getEnv "SLUG";
        rev = builtins.getEnv "REV";
        hit = builtins.filter (
          node:
          let
            l = node.locked or { };
          in
          (l.type or "") == "github"
          && ((l.owner or "") + "/" + (l.repo or "")) == slug
          && (l.rev or "") == rev
        ) (builtins.attrValues lock.nodes);
      in
      if hit == [ ] then "" else (builtins.head hit).locked.narHash
    '
}

store_path_of() {
    NAR_HASH="$1" nix_eval_str '
      (derivation {
        name = "source";
        system = "x86_64-linux";
        builder = "/bin/sh";
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = builtins.getEnv "NAR_HASH";
      }).outPath
    '
}

prime_input_from_git() {
    local slug=$1 rev=$2 narhash want got

    narhash=$(narhash_of "${slug}" "${rev}")
    if [[ -z ${narhash} ]]; then
        echo "flake.lock に narHash が見つからない: ${slug} ${rev}" >&2
        return 1
    fi

    want=$(store_path_of "${narhash}")
    got=$(SLUG="${slug}" REV="${rev}" nix_eval_str '
      (builtins.fetchGit {
        url = "https://github.com/" + builtins.getEnv "SLUG";
        rev = builtins.getEnv "REV";
        allRefs = true;
      }).outPath
    ')

    if [[ ${got} != "${want}" ]]; then
        echo "git 由来の tree が tarball と一致しない: ${slug} ${rev}" >&2
        echo "  want=${want}" >&2
        echo "  got =${got}" >&2
        return 1
    fi
}

# ビルドし、github archive の 403 で落ちたら該当 input を git 経由で入れて再試行する。
# 先回りで全部入れると vim/vim のような巨大 repo まで引くので、必要になった分だけ。
# substituter から引ける input はそもそもここへ来ない。
build_activation_package() {
    local err url slug rev out
    err=$(mktemp)

    for _ in $(seq 1 "${MAX_PRIME_ROUNDS}"); do
        if out=$(
            "${NIX_PROFILE_DIR}/bin/nix" build \
                --no-link --print-out-paths --accept-flake-config \
                "${DOTFILES_DIR}#homeConfigurations.claude-web.activationPackage" 2>"${err}"
            ); then
            rm -f "${err}"
            printf '%s\n' "${out}"
            return 0
        fi

        url=$(grep -o 'https://github.com/[^/]\+/[^/]\+/archive/[0-9a-f]\+\.tar\.gz' "${err}" | head -1)
        if [[ -z ${url} ]]; then
            cat "${err}" >&2
            rm -f "${err}"
            return 1
        fi

        slug=${url#https://github.com/}
        slug=${slug%%/archive/*}
        rev=${url##*/archive/}
        rev=${rev%.tar.gz}

        log "input を git 経由で取得する: ${slug}"
        prime_input_from_git "${slug}" "${rev}" || { rm -f "${err}"; return 1; }
    done

    echo "input の事前投入が ${MAX_PRIME_ROUNDS} 回を超えた" >&2
    rm -f "${err}"
    return 1
}

activate_home_manager() {
    log "homeConfigurations.claude-web をビルドする"
    local activation_package
    activation_package=$(build_activation_package)

    log "activate: ${activation_package}"
    # home-manager の activate は USER を参照する。非ログインシェルでは未設定なので
    # ここで明示する（未設定だと unbound variable で即死する）。
    HOME="${HOME:-/root}" USER="${USER:-root}" "${activation_package}/activate"
}

# settings.json の hook（`cchook -event <E>`）は Claude Code が直接 spawn する。この
# プロセスはログインシェルを経由せず profile を読まないため、PATH に
# ~/.nix-profile/bin が入らず bare な `cchook` が解決できない。既定の PATH に載って
# いる /usr/local/bin から HM プロファイルの実体へ symlink を張って解決させる。
link_hook_binaries() {
    log "hook から見える PATH へ symlink を張る"
    local name
    for name in cchook tirith uv; do
        if [[ -x ${HOME}/.nix-profile/bin/${name} ]]; then
            ln -sfn "${HOME}/.nix-profile/bin/${name}" "/usr/local/bin/${name}"
        fi
    done
}

main() {
    if [[ ${EUID} -ne 0 ]]; then
        echo "root で実行すること（--init none の Nix は root 専用）" >&2
        exit 1
    fi

    export NIX_REMOTE=daemon
    [[ -f ${CCR_CA_BUNDLE} ]] && export NIX_SSL_CERT_FILE="${CCR_CA_BUNDLE}"

    install_nix
    start_daemon
    activate_home_manager
    link_hook_binaries

    log "完了。~/.claude 配下の skills / agents / hooks / settings.json を配置した"
}

main "$@"
