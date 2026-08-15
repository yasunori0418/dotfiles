# herdr-plus projects

herdr ワークスペースのテンプレートを 1 プロジェクト 1 ファイル（`*.toml`）で置く。
ファイル名は任意（内容の `name` が表示名になる）。

`cloudmanic.herdr-plus.projects` アクションで全画面のブラウザが開き、選ぶと
`working_dir` を root にしたワークスペースが `[[tabs]]` の順に構築される。
ブラウザ内で **Enter** は通常のワークスペース、**ctrl+g** は git worktree として開く。

```toml
name = "dotfiles"
description = "Nix dotfiles"
group = "yasunori0418"            # 任意。ブラウザ上の見出しでまとめる
working_dir = "~/dotfiles"        # ~ と $VAR は展開される

[[tabs]]
name = "editor"
command = "nvim"

[[tabs]]
name = "terminal"                 # command 無しなら空のシェル

# 1 つの tab は最大 4 pane に分割できる。単一の command の代わりに
# [[tabs.panes]] を並べる。2 つ目以降の split は直前の pane からの分割方向で、
# "down"（既定）か "right"。
[[tabs]]
name = "watch"

[[tabs.panes]]
label = "build"
command = "make nput-dryrun"

[[tabs.panes]]
label = "log"
command = "tail -f /tmp/build.log"
split = "down"
```

このディレクトリは nput 管理下（dotfiles の実体への symlink）なので、
ファイルを足せば即反映される。
