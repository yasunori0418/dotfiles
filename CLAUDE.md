# CLAUDE.md

## リポジトリ概要

NixOS（Linux）、nix-darwin（macOS）、スタンドアロンHome Manager設定をサポートするマルチプラットフォームNix dotfilesリポジトリ。
Nix flakesと`flake-parts`を使用したモジュラー設定管理を採用。

### ディレクトリ構成

- **`/home-manager/`**: クロスプラットフォームのユーザー環境設定（`linux/`、`macos/`）
- **`/nixos/`**: Linuxシステム設定（マシン固有プロファイル）
- **`/nix-darwin/`**: macOSシステム設定
- **`/home/`**: 実際のdotfiles（`home-manager/lib/file-map.nix`経由でシンボリックリンク）
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
