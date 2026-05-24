---
name: nix-devenv
description: "Nix + flake-parts 開発環境の構築パターン: root flake.nix（成果物）+ dev/flake.nix（devShell + CI シェル）を direnv で読み込む構成、および GitHub Actions CI テンプレートを提供する。このスキルは /nix-devenv と明示的に呼び出されたときのみ使用する。キーワードマッチによる自動起動はしない。"
---

# nix-devenv

Nix + flake-parts 開発環境のセットアップパターン。
ルートの `flake.nix` はプロジェクト成果物専用、開発ツールは `dev/flake.nix` に分離し direnv で読み込む。
同じ `dev/flake.nix` の `ci` devShell を GitHub Actions でも使う。

## 構成概要

```
<project>/
├── flake.nix          # プロジェクト成果物 + treefmt-nix (formatter) のみ
├── flake.lock
├── dev/
│   ├── flake.nix      # 開発ツール (default) + CI シェル (ci) 定義
│   └── flake.lock
├── .envrc             # use flake ./dev  ← .gitignore に含める（ユーザーが手動で作成）
├── example.envrc      # .envrc のサンプル（リポジトリにコミットする）
└── .github/
    ├── actions/
    │   └── setup-nix/
    │       └── action.yaml
    └── workflows/
        └── check.yml
```

## Key decisions（設計の理由）

- **treefmt は root `flake.nix` に定義する**: `nix fmt` がプロジェクトルートで動くようにするため。dev/ に置くと root での `nix fmt` が効かない
- **`dev/flake.nix` から `inputs'.root.formatter` で formatter を参照**: treefmt 設定を重複させない。dev/ に treefmt-nix を独立して追加してはいけない
- **`dev/flake.nix` の `nixpkgs`・`flake-parts` は root への `follows` にする**: lock の分散を防ぎ root と完全に同一バージョンを使う。standalone URL を書いてはいけない
- **`devShells.ci` は TERM = "dumb" + 最小構成**: ターミナル制御コードが CI ログを汚さないようにするため
- **`.envrc` は .gitignore 対象、`example.envrc` をコミットする**: ユーザー固有の設定は追跡しない

## 1. ルート flake.nix

```nix
{
  description = "<プロジェクト説明>";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.treefmt-nix.flakeModule ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem = { pkgs, ... }: {
        treefmt = {
          projectRootFile = "flake.nix";
          programs.nixfmt = {
            enable = true;
            package = pkgs.nixfmt;
          };
          # 追加フォーマッタ例: programs.prettier.enable = true;
          # 追加フォーマッタ例: programs.rustfmt.enable = true;
        };
      };
      flake = {
        # プロジェクト固有の outputs をここに追加
        # 例（Nixライブラリ系）:
        #   lib = import ./lib;
        #   homeManagerModules.default = ./modules/home-manager.nix;
        #   nixosModules.default      = ./modules/nixos.nix;
        #   darwinModules.default     = ./modules/nix-darwin.nix;
      };
    };
}
```

> `treefmt-nix.flakeModule` を import すると `perSystem.config.treefmt.build.wrapper` が
> `packages.formatter` として自動公開される。`dev/flake.nix` はこれを `inputs'.root.formatter` で参照する。

## 2. dev/flake.nix

```nix
{
  description = "<プロジェクト名> development environment";

  inputs = {
    root.url = "path:../";
    nixpkgs.follows = "root/nixpkgs";
    flake-parts.follows = "root/flake-parts";
    # NG: treefmt-nix を ここに独立して追加してはいけない
    # OK: root の formatter は inputs'.root.formatter 経由で使う
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        { inputs', pkgs, ... }:
        {
          devShells = {
            # ローカル開発用: LSP・linter・formatter フル搭載
            default = pkgs.mkShell {
              packages = with pkgs; [
                statix           # Nix linter
                nixd             # Nix language server
                inputs'.root.formatter  # root の treefmt formatter を再利用
                # プロジェクト固有ツールを追加
                # 例（Rust）: cargo rustfmt rust-analyzer
                # 例（Python）: ruff pyright
              ];
              shellHook = ''
                export REPO_ROOT=$(git rev-parse --show-superproject-working-tree --show-toplevel)
              '';
            };

            # CI 用: 最小構成 + TERM=dumb
            ci = pkgs.mkShell {
              packages = with pkgs; [
                # テスト実行に必要な最小限のツールのみ
              ];
              env = {
                TERM = "dumb";
              };
              shellHook = ''
                export REPO_ROOT=$(git rev-parse --show-superproject-working-tree --show-toplevel)
              '';
            };
          };
        };
    };
}
```

## 3. .envrc / example.envrc

`example.envrc`（リポジトリにコミットする）:
```bash
#!/usr/bin/env bash

use flake ./dev
```

`.envrc` はユーザーが `example.envrc` をコピーして作成する（`.gitignore` 対象）。
`.gitignore` に追加:
```
.envrc
.direnv/
```

## 4. GitHub Actions: setup-nix composite action

`.github/actions/setup-nix/action.yaml`:
```yaml
name: 'Setup Nix'
description: 'Install Nix and configure Cachix'
inputs:
  cachix-auth-token:
    description: 'Cachix authentication token'
    required: false
runs:
  using: 'composite'
  steps:
    - name: Install Nix
      uses: cachix/install-nix-action@1ca7d21a94afc7c957383a2d217460d980de4934 # v31.10.1
      with:
        github_access_token: ${{ github.token }}

    - name: Setup Cachix
      uses: cachix/cachix-action@3ba601ff5bbb07c7220846facfa2cd81eeee15a1 # v16
      with:
        name: <cachix-cache-name>
        authToken: ${{ inputs.cachix-auth-token }}
```

> `cachix-auth-token` を省略した場合は read-only でキャッシュを使うだけになる。
> `cachix-cache-name` は cachix.io で作成したキャッシュ名（プレースホルダーのまま渡し、ユーザーが差し替える）。

## 5. GitHub Actions: CI ワークフロー

`.github/workflows/check.yml`:
```yaml
name: Nix Flake Check

on:
  push:
    branches-ignore:
      - main        # main は PR 経由でのみ更新するため push を除外
  pull_request:

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd # v6.0.2

      - name: Setup Nix
        uses: ./.github/actions/setup-nix
        with:
          cachix-auth-token: ${{ secrets.CACHIX_AUTH_TOKEN }}

      - name: nix flake check
        run: nix flake check

      # dev/flake.nix の ci シェルで任意コマンドを実行する場合:
      # - name: Run tests
      #   run: nix develop '.?dir=dev#ci' -c <コマンド>
      #   env:
      #     TERM: "dumb"
```

### matrix で複数 system をテストする場合:
```yaml
strategy:
  matrix:
    include:
      - os: ubuntu-latest
        system: x86_64-linux
      - os: ubuntu-24.04-arm
        system: aarch64-linux
      - os: macos-latest
        system: aarch64-darwin
runs-on: ${{ matrix.os }}
```

## Setup checklist

- [ ] `flake.nix` 作成・更新 → `nix flake check` で評価確認
- [ ] `dev/flake.nix` 作成 → `nix develop ./dev` で動作確認
- [ ] `example.envrc` 作成・コミット
- [ ] `.gitignore` に `.envrc` / `.direnv/` を追加
- [ ] ユーザーが `cp example.envrc .envrc && direnv allow` で入れることを確認
- [ ] `dev/flake.nix` に `ci` devShell が必要か判断（CI で `nix develop` を使う場合は必須）
- [ ] `.github/actions/setup-nix/action.yaml` 作成
- [ ] `.github/workflows/check.yml` 作成

## Actions hash 更新方法

ハッシュは時間とともに陳腐化する。スキルのテンプレートを更新するときは必ず以下でタグの最新ハッシュを取得し、SKILL.md のテンプレートも合わせて更新すること。

```bash
gh api repos/cachix/install-nix-action/git/refs/tags/v31.10.1 | jq -r '.object.sha'
gh api repos/cachix/cachix-action/git/refs/tags/v16 | jq -r '.object.sha'
gh api repos/actions/checkout/git/refs/tags/v6.0.2 | jq -r '.object.sha'
```
