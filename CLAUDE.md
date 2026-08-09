# CLAUDE.md

## リポジトリ概要

NixOS（Linux）、nix-darwin（macOS）、スタンドアロンHome Manager設定をサポートするマルチプラットフォームNix dotfilesリポジトリ。
Nix flakesと`flake-parts`を使用したモジュラー設定管理を採用。

### ディレクトリ構成

- **`/home-manager/`**: クロスプラットフォームのユーザー環境設定（`linux/`、`macos/`）
- **`/nixos/`**: Linuxシステム設定（マシン固有プロファイル）
- **`/nix-darwin/`**: macOSシステム設定
- **`/home/`**: 実際のdotfiles（`home-manager/nputFileMap.nix`経由でシンボリックリンク）
- **`/nix-overlays/`**: カスタムパッケージ定義

### プラットフォーム固有の注意点

- **ユーザー名**: Linuxでは`yasunori`、macOSでは`taiki.watanabe`
- **Neovim設定**: `home/.config/nvim/`で管理（dpp.vim + Denops構成）

## 主要コマンド

```bash
make nix-rebuild    # クロスプラットフォームリビルド（OS自動検出）
make nixos          # NixOS rebuild switch
make nix-darwin     # nix-darwin rebuild switch
nix fmt             # コードフォーマット（treefmt管理）
make help           # 全コマンド一覧
```

## nput による設定ファイル配置

`~/.claude/*`・`~/.config/*` などの配置は home-manager の `home.file` ではなく
[nput](https://github.com/yasunori0418/nput) が行う（home-manager にはモジュールとして
import され、`home.activation` から起動される）。

entries の定義は `home-manager/nputEntries.nix` に集約し、以下 2 経路が共有する。

- **home-manager 経由**: `home-manager/{linux,macos}/nput.nix` → switch 時に activation から適用
- **flake-parts 経由**: `flake-parts/nput.nix` の `nput.default` → `nput` CLI から直接適用

両者は同じ entries から同一の manifest を生成し、同じ generation profile
（`<state>/nix/profiles/nput/default`）を共有する。よって switch を挟まずに
CLI から配置を反映できる。

```bash
make nput-dryrun      # 配置差分のプレビュー（副作用なし）
make nput-apply       # 配置を適用（home-manager switch 不要）
make nput-recopy      # copy 配置（~/.claude/settings.json）を再配置
make nput-skills      # project mode: .claude/skills/ へ配置
make nput-generations # 世代一覧
make nput-rollback    # 直前の世代へロールバック
```

`~/.claude/settings.json` は `home-manager/claudeSettings.nix` から生成した JSON を
`method = "copy"` で配置する（Claude Code の TUI が書き戻せるようにするため）。
copy は place-once なので switch では追従せず、Nix 側の変更を反映するには
`make nput-recopy` が要る。逆に TUI が書き戻した内容は recopy で失われるため、
恒久化したい変更は `claudeSettings.nix` へ戻す（SSOT は Nix 側）。
