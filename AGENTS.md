# AGENTS.md

NixOS・nix-darwin・スタンドアロン Home Manager を 1 つの flake（`flake-parts`）で管理する dotfiles リポジトリ。

- **`/home/`**: 手書きの dotfiles 実体。layat が `$HOME` 配下へ symlink する配置元
- **ユーザー名**: Linux では `yasunori`、macOS では `taiki.watanabe`
- **フォーマット**: `nix fmt`（treefmt 管理）
- **make ターゲット一覧**: `make help`

## layat による設定ファイル配置

`~/.claude/*`・`~/.config/*` などの配置は
[layat](https://github.com/yasunori0418/layat) が行う。entries は役割ごとの profile
（`home` / `desktop` / `vim` / `claude` / `claude-settings` / `herdr-plugins` / `gh_extension`）に分かれ、
定義は `home-manager/layat/profiles/<profile>.nix`（ファイル名が profile 名）。
profile の切り方・`subdir`・二経路（home-manager activation と `layat` CLI）の設計は
`home-manager/layat/entries.nix` の冒頭コメントを正とする。

home-manager 経由と CLI 経由は同じ generation profile を共有するので、
配置の変更は home-manager switch を挟まずに CLI から反映できる。

```bash
make layat-dryrun [P=<profile>] # 配置差分のプレビュー（副作用なし）
make layat-apply  [P=<profile>] # 配置を適用（home-manager switch 不要）
make layat-recopy               # claude-settings の copy（~/.claude/settings.json）を再配置して inject
make layat-generations P=<profile> # 世代一覧（P 必須）
make layat-rollback    P=<profile> # 直前の世代へロールバック（P 必須）
```

`P` を省略した apply / dryrun は home mode の全 profile が対象。

### 配置するファイルを増減する手順

1. `home/` 配下に実体を足す（または消す）
2. 該当する `home-manager/layat/profiles/<profile>.nix` の entries を編集する。
   profile を足すときはファイルを足すだけでよい（`profiles/` は readDir で列挙される）
3. 新規ファイルは `git add` する（Nix は git 管理下のファイルしか見ない）
4. `make layat-dryrun` で差分を確かめ、`make layat-apply` で反映する

同じ target を 2 つの profile に書くと `entries.nix` の assert で eval が止まる。
`nix flake update yasunori-skills` のあとも `make layat-apply`（または `P=claude`）で反映する。

### `~/.claude/settings.json`

`home-manager/claudeSettings.nix` から生成した JSON を `method = "copy"` で配置する
（Claude Code の TUI が書き戻せるようにするため）。
copy は place-once なので switch では追従せず、Nix 側の変更を反映するには
`make layat-recopy` が要る。逆に TUI が書き戻した内容は recopy で失われるため、
恒久化したい変更は `claudeSettings.nix` へ戻す（SSOT は Nix 側）。
