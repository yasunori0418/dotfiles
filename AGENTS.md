# CLAUDE.md

## リポジトリ概要

NixOS（Linux）、nix-darwin（macOS）、スタンドアロンHome Manager設定をサポートするマルチプラットフォームNix dotfilesリポジトリ。
Nix flakesと`flake-parts`を使用したモジュラー設定管理を採用。

### ディレクトリ構成

- **`/home-manager/`**: クロスプラットフォームのユーザー環境設定（`linux/`、`macos/`）
- **`/nixos/`**: Linuxシステム設定（マシン固有プロファイル）
- **`/nix-darwin/`**: macOSシステム設定
- **`/home/`**: 実際のdotfiles（`home-manager/layat/entries.nix`経由でシンボリックリンク）
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

## layat による設定ファイル配置

`~/.claude/*`・`~/.config/*` などの配置は
[layat](https://github.com/yasunori0418/layat) が行う（home-manager にはモジュールとして
import され、`home.activation` から起動される）。

entries は役割ごとの profile に分かれる。定義は `home-manager/layat/profiles.nix`
（profile × OS）にあり、`home-manager/layat/entries.nix` が `{ <profile> = entries; }` に
畳んで以下 2 経路へ同じ名前で供給する。

| profile | 中身 |
|---|---|
| `home` | `home/` の手書き設定のうち下記以外の全部（shell・git・CLI ツール・ターミナル等） |
| `desktop` | WM・GUI・テーマ・入力メソッド・壁紙（nixpkgs 由来の gtk css を含む） |
| `nvim` | nvim / dpp / vim / ideavim と nixpkgs 由来の treesitter parser |
| `claude` | `~/.claude/` 配下の symlink 全部（CLAUDE.md・skills・agents・hooks・mcp-servers.json） |
| `claude-settings` | `~/.claude/settings.json`（`method = "copy"`）だけ |
| `herdr-plugins` | `~/.local/share/herdr-plugins/*` |

- **home-manager 経由**: `home-manager/layat/default.nix` の `layat.configs.<profile>` → switch 時に
  activation（`layat apply --all --manifest <profile>=<link-farm> …` の 1 回起動）から適用
- **flake-parts 経由**: `flake-parts/layat.nix` の `layat.<profile>` → `layat` CLI から直接適用

両者は同じ entries から同一の manifest を生成し、profile ごとに同じ generation profile
（`<state>/nix/profiles/layat/<profile>`）を共有する。よって switch を挟まずに
CLI から配置を反映できる。profile 名は両経路で 1:1 に揃える必要があり、
`layat/entries.nix` が唯一の供給元になることで構造的に保たれる。同じ target を
2 つの profile に書くと `layat/entries.nix` の assert で eval が止まる。

```bash
make layat-dryrun [P=<profile>] # 配置差分のプレビュー（副作用なし）
make layat-apply  [P=<profile>] # 配置を適用（home-manager switch 不要）
make layat-recopy               # claude-settings の copy（~/.claude/settings.json）を再配置して inject
make layat-skills               # project mode: .claude/skills/ へ配置
make layat-generations P=<profile> # 世代一覧（P 必須）
make layat-rollback    P=<profile> # 直前の世代へロールバック（P 必須）
```

`P` を省略した apply / dryrun は home mode の全 profile（`--all --home-root`）が対象で、
project mode の `skills` は含まない。`nix flake update yasunori-skills` のあとは
`make layat-apply`（または `make layat-apply P=claude`）で反映する。

`~/.claude/settings.json` は `home-manager/claudeSettings.nix` から生成した JSON を
`method = "copy"` で配置する（Claude Code の TUI が書き戻せるようにするため）。
copy は place-once なので switch では追従せず、Nix 側の変更を反映するには
`make layat-recopy` が要る。逆に TUI が書き戻した内容は recopy で失われるため、
恒久化したい変更は `claudeSettings.nix` へ戻す（SSOT は Nix 側）。
