#!/usr/bin/env bash

# Claude Code on the web のセッションへ、この dotfiles を起点にした開発環境を用意する。
#
#   1. Nix を multi-user レイアウトでインストール（NixOS/nix-installer）
#   2. nix-daemon を起動（systemd が無いので自前で上げる）
#   3. homeConfigurations.claude-web の activationPackage をビルドして activate
#
# コンテナは毎セッション作り直されるため、セッション開始ごとに 1 回流す想定。環境の
# setup script へ登録しておくと Claude Code の起動前に走るので、配置した
# ~/.claude/settings.json の hook もそのセッションから有効になる。
#
# 前提:
#   - egress policy がサードパーティ repo の `github.com/<owner>/<repo>/archive/*.tar.gz`
#     を許可していること。flake の input は `github:` で書かれているため、塞がれている
#     環境では入力解決の時点で 403 になる。github.com がホストとして通ることとは別で、
#     既定の claude-web policy はセッションに紐づいた repo だけに絞る。
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

activate_home_manager() {
    log "homeConfigurations.claude-web をビルドする"
    local activation_package
    activation_package=$(
        "${NIX_PROFILE_DIR}/bin/nix" build \
            --no-link --print-out-paths --accept-flake-config \
            "${DOTFILES_DIR}#homeConfigurations.claude-web.activationPackage"
    )

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
