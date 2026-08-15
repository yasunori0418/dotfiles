#!/usr/bin/env bash

# ~/.local/share/herdr-plugins/ 配下へ nput が配置した herdr プラグインを
# herdr のレジストリ（~/.config/herdr/plugins.json）へ登録する。
#
# herdr はプラグインをディレクトリ走査で発見せず、レジストリに登録された
# plugin_root の絶対パスだけを見る。よって nput で配置しただけでは有効にならず
# この link が要る。
#
# `herdr plugin link` は
#   - 同一 plugin_id を上書きする（冪等。毎 switch 実行してよい）
#   - herdr サーバが起動していなくても plugins.json へ直接書ける
#     （activation 実行時にサーバが居なくても失敗しない）
#   - 渡されたパスを canonicalize して実体（= store パス）を記録する
# ため、プラグイン更新で store パスが変わるたびに再実行して登録を更新する。
#
# home-manager の activation（home-manager/link-herdr-plugins.nix）と
# `make herdr-plugin-link` の両方から同じ処理を呼ぶための実体。

set -euo pipefail

PLUGIN_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/herdr-plugins"
readonly PLUGIN_DIR

# herdr の在り処は呼び出し元によって解決手段が違う。
#   - home-manager の activation: systemd の service が PATH を coreutils 等の
#     最小構成へ固定するので PATH 解決では見つからない。Nix 側で解決した
#     絶対パスを HERDR_BIN で渡してもらう。
#   - `make herdr-plugin-link`（対話シェル）: PATH から引ければ十分。
HERDR_BIN="${HERDR_BIN:-$(command -v herdr || true)}"
readonly HERDR_BIN

# switch は herdr のインストール有無に依らず通す必要があるため、
# 前提が欠けているときはスキップして正常終了する。
if [[ -z ${HERDR_BIN} || ! -x ${HERDR_BIN} ]]; then
    echo "herdr-plugin-link: herdr not found (set HERDR_BIN to override); skipped" >&2
    exit 0
fi

if [[ ! -d ${PLUGIN_DIR} ]]; then
    echo "herdr-plugin-link: ${PLUGIN_DIR} not found; skipped" >&2
    exit 0
fi

# プラグインを増やしてもこのスクリプトを触らずに済むよう、
# herdr-plugin.toml を持つディレクトリを走査して対象にする。
linked=0
for plugin in "${PLUGIN_DIR}"/*; do
    [[ -f ${plugin}/herdr-plugin.toml ]] || continue

    if "${HERDR_BIN}" plugin link "${plugin}" >/dev/null; then
        echo "herdr-plugin-link: linked ${plugin}"
        linked=$((linked + 1))
    else
        # 1 つのプラグインの失敗（manifest 不正・min_herdr_version 不足など）で
        # 他のプラグインの登録や switch 全体を巻き込まない。
        echo "herdr-plugin-link: failed to link ${plugin}" >&2
    fi
done

if [[ ${linked} -eq 0 ]]; then
    echo "herdr-plugin-link: no plugins found under ${PLUGIN_DIR}" >&2
fi
