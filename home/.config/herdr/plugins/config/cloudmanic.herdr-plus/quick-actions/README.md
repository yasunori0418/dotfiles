# herdr-plus quick-actions

一発実行のアクションを 1 つ 1 ファイル（`*.toml`）で置く。
`cloudmanic.herdr-plus.quick-actions` アクションで fuzzy ランチャーが開き、
選ぶと「起動した pane の cwd」でコマンドが走る。

```toml
name = "GitHub"
description = "Open https://github.com"
# {{opener}} は OS 既定の open コマンド（open / xdg-open / Start-Process）に展開される
command = "{{opener}} https://github.com"
```

`type` は省略時 `"command"`。ほかに `select` / `form` がある（README 参照:
https://github.com/cloudmanic/herdr-plus#quick-actions ）。

## 出力を読む用途には使えない

quick-action は**副作用を起こすもの専用**と考える。一覧表示のような
「出力を読みたい」ものは動かない:

- アクションは picker の TUI を抜けた直後、**pane が破棄される直前**に実行される
  （herdr-plus の quickactionspicker.go）。出力はその pane に出て即座に消える
- `read` で待たせる回避も効かない。herdr-plus は `cmd.Stdout` / `cmd.Stderr` しか
  設定せず **`cmd.Stdin` を繋がない**ため、`read` は即 EOF で返る

出力を読みたいものは herdr 本体の keybinding を使う。
`~/.config/herdr/config.toml` の `[[keys.command]]` に `type = "popup"` で書き、
`read` で閉じるのを待たせる（例: `prefix+shift+s` のセッション一覧）。

リポジトリ固有のアクションは、そのリポジトリの `.herdr-plus/quick-actions/` に置くと
そのディレクトリで起動したときだけ一覧に出る（こちらは herdr-plus が生成しない opt-in）。

## seed について

herdr-plus はこのディレクトリが**存在しないとき**に限り、同梱の例
（`examples/quick-actions/`）を書き込む。nput が symlink を張るので既に存在し、
seed は走らない。例が要るなら upstream から手で持ってくる。

このディレクトリは nput 管理下（dotfiles の実体への symlink）なので、
ファイルを足せば即反映される。
