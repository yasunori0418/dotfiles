# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## リポジトリ概要

NixOS（Linux）、nix-darwin（macOS）、スタンドアロンHome Manager設定をサポートするマルチプラットフォームNix dotfilesリポジトリです。
異なるシステムとハードウェアプロファイル間でのモジュラー設定管理に、モダンなNix flakesと`flake-parts`を使用したアーキテクチャを採用しています。

## コアアーキテクチャ

### Flake構造

- **flake.nix**: 3つの設定タイプを定義するメインエントリーポイント：
  - `nixosConfigurations`: Linuxシステム（`yasunori-laptop`、`yasunori-desktop`、`macx64OrbStack`）
  - `darwinConfigurations`: macOSシステム（`LGPM-0151`）
  - `homeConfigurations`: スタンドアロンユーザー環境（`linux`、`macos`）

### 設定の構成

- **`/home-manager/`**: プラットフォーム固有の`linux/`と`macos/`設定を持つクロスプラットフォームユーザー環境
- **`/nixos/`**: マシン固有プロファイル（`ThinkPadE14Gen2/`、`Desktop/`、`MacX64_OrbStack/`）を持つLinuxシステム設定
- **`/nix-darwin/`**: Homebrew統合を含むmacOSシステム設定
- **`/home/`**: ファイルマッピングシステム経由でシンボリックリンクされる実際のdotfiles
- **`/flake-parts/`**: 開発環境とフォーマット設定

### ファイルマッピングシステム

このリポジトリは`home-manager/lib/file-map.nix`内の洗練されたファイルマッピングシステムを使用し、
`/home/`から適切な場所へのdotfilesのシンボリックリンクを処理します。これにより、統一されたdotfile構造を維持しながらプラットフォーム固有のファイル配置が可能になります。

### Neovim設定ディレクトリの構造要約

@home/.config/nvim
主な特徴：TypeScript/Deno統合、豊富なLSP設定、日本語入力（SKK）対応、Git統合、AI支援機能など、現代的な開発環境を網羅した包括的な設定です。
このディレクトリは以下の主要コンポーネントで構成されています：

#### コア設定

- **init.lua**: エントリーポイント
- **rc/**: 基本設定（オプション、自動コマンド、コマンド定義）
- **lua/user/**: カスタムLua関数とユーティリティ

#### プラグイン管理

- **`dpp/`**: dpp.vim設定（TypeScript）
- **`toml/`**: プラグイン定義ファイル群（機能別分類）
- **`hooks/`**: プラグイン初期化スクリプト
- **`lua/user/plugins/`**: `hooks/`で呼び出す各プラグイン用のスクリプト
- **`autoload`**: vimscriptによるプラグイン開発のサンドボックス用ディレクトリ
    - 最終的にプラグイン化するスクリプトを配置

#### 言語サポート

- **`after/lsp/`**: LSPサーバー設定
- **`after/queries/`**: Tree-sitter構文ハイライト拡張
- **`snippets/`**: コードスニペット定義

#### 開発支援

- **`denops/`** : Denops（Deno）ベースプラグイン
- **`test/`**: Lua関数のテストコード
- **`hooks/dap.lua`**: デバッグ環境設定

## 共通開発コマンド

### ビルドとデプロイ

```bash
# クロスプラットフォームリビルド（OS自動検出）
make nix-rebuild

# プラットフォーム固有リビルド
make nixos              # NixOS rebuild switch
make nix-darwin         # nix-darwin rebuild switch
make nix-home-linux     # Home Manager for Linux
make nix-home-macos     # Home Manager for macOS

# ガベージコレクション
make nix-gc
```

### 開発環境

```bash
nix develop             # ツール付き開発シェルに入る（vim-startuptime、hyperfine、stylua、luaツール、LSPサーバー）

nix fmt                 # 全コードをフォーマット

make help               # カラー出力付きインタラクティブヘルプ
make help-fzf           # fzfでターゲットを検索して実行
```

### 専用ツール
```bash
# Neovim開発
make nvim-bench         # 起動時間のベンチマーク
make nvim-update        # Dpp経由でNeovimプラグインを更新

# パフォーマンスベンチマーク
make zsh-bench          # hyperfineでzsh起動をベンチマーク

# VSCode管理
make vscode-setup       # 拡張機能のインストールとセットアップ
make vscode-ext         # 拡張機能リストの更新
make vscode-byebye      # 拡張機能のアンインストールとクリーンアップ
```

## 開発パターン

### 新しい設定の追加

1. **新しいマシンプロファイル**: 適切なプラットフォーム（`nixos/`、`nix-darwin/`）下にディレクトリを作成
2. **クロスプラットフォームパッケージ**: `home-manager/{linux,macos}/packages.nix`に追加
3. **システムサービス**: 適切な分類で`settings/`ディレクトリに追加
4. **Dotfiles**: `/home/`にファイルを追加し、ファイルマッピング設定で参照

### プラットフォーム固有の考慮事項

- **Linux**: i3wm、systemdサービス、ハードウェア固有設定を使用
- **macOS**: Homebrewを統合、システム管理にnix-darwinを使用、macOS固有ツール（Karabiner、AeroSpace）を含む
- **ユーザー名**: プラットフォーム間で異なる（Linuxでは`yasunori`、macOSでは`taiki.watanabe`）

## 主要設定ファイル

- **ターゲットシステム**: 特定のハードウェア/ユーザープロファイルでflake.nixアウトプットに定義
- **開発ツール**: LSPサーバーと開発ユーティリティで`flake-parts/devenv.nix`に設定
- **コードフォーマット**: 複数のフォーマッター（nixfmt、stylua、statix、deno、beautysh）でtreefmtによって管理
- **パッケージオーバーレイ**: `nix-overlays/`でカスタムパッケージを定義
- **Neovim**: 標準的なvimのruntimepathに加えて、個人設定特有のディレクトリを追加した`home/.config/nvim`にてneovimの設定を管理

## テストと検証

- **OrbStack統合**: macOS上でLinux設定をテストするための`macx64OrbStack`プロファイル
- **クロスプラットフォーム互換性**: Home Manager設定はスタンドアロンとNixOS/nix-darwin統合の両方で動作
- **自動更新**: 依存関係管理のためのRenovateボット設定
