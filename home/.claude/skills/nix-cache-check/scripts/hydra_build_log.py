#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["certifi"]
# ///
"""Hydra のビルド詳細ページから失敗ステップのログ末尾だけを抜き出す。

Hydra の /build/<id> は Accept: application/json で構造化データを返すが、
失敗時のビルドログ末尾は JSON に含まれず HTML の "Failed build steps"
テーブル内にしか埋め込まれていない。ここだけは HTML を読む必要がある。

uv の inline script metadata（PEP 723）で Python バージョンと依存を固定し、
実行環境差による再現性の揺れを避ける。`certifi` を明示依存にしているのは、
uv が管理する隔離 Python はホスト（NixOS 等）の CA 証明書ストアを見つけ
られず SSL 検証に失敗することがあるため — 証明書束をホスト環境に頼らず
依存として固定することも再現性のうち。呼び出し側（nix-cache-check.sh）は
`uv run` 経由でこのファイルを実行する。
"""
import re
import ssl
import sys
import urllib.request

import certifi


def main() -> None:
    if len(sys.argv) != 2:
        print("usage: hydra_build_log.py <build-id>", file=sys.stderr)
        sys.exit(1)

    build_id = sys.argv[1]
    url = f"https://hydra.nixos.org/build/{build_id}"
    ctx = ssl.create_default_context(cafile=certifi.where())
    with urllib.request.urlopen(url, context=ctx) as resp:
        html = resp.read().decode("utf-8", errors="replace")

    m = re.search(r"Last 25 log lines:.*?</em>", html, re.S)
    if not m:
        print(
            "(失敗ステップのログが見つかりませんでした。ビルドが成功しているか、"
            f"進行中の可能性があります。詳細ページを直接確認してください: {url})"
        )
        return

    text = re.sub(r"<[^>]+>", " ", m.group(0))
    for entity, char in (
        ("&gt;", ">"),
        ("&lt;", "<"),
        ("&amp;", "&"),
        ("&#39;", "'"),
        ("&quot;", '"'),
    ):
        text = text.replace(entity, char)
    text = re.sub(r"[ \t]+", " ", text)
    print(text.strip())


if __name__ == "__main__":
    main()
