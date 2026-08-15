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

リポジトリ固有のアクションは、そのリポジトリの `.herdr-plus/quick-actions/` に置くと
そのディレクトリで起動したときだけ一覧に出る（こちらは herdr-plus が生成しない opt-in）。

## seed について

herdr-plus はこのディレクトリが**存在しないとき**に限り、同梱の例
（`examples/quick-actions/`）を書き込む。nput が symlink を張るので既に存在し、
seed は走らない。例が要るなら upstream から手で持ってくる。

このディレクトリは nput 管理下（dotfiles の実体への symlink）なので、
ファイルを足せば即反映される。
