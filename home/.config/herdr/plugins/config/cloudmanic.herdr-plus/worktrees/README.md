# herdr-plus worktrees

git worktree を作った / 開いたときに自動で流し込むレイアウトを、
1 レイアウト 1 ファイル（`*.toml`）で置く。ファイル名は任意。

herdr の `worktree.created` / `worktree.opened` イベントで発火する（手で叩くものではない）。
マッチするレイアウトが無ければ何もしない。

```toml
repo = "dotfiles"       # worktree 元のリポジトリ名（basename）に大文字小文字を無視してマッチ
# branch = "main"       # 任意。特定ブランチだけに絞る（repo のみのものより優先される）

[[tabs]]
name = "editor"
command = "nvim"

[[tabs]]
name = "terminal"
```

- `repo = "*"` はワイルドカード。専用レイアウトを持たない全リポジトリに適用される
- `[[tabs]]` の書式は projects と同じ（`[[tabs.panes]]` の分割も使える）
- **有効・無効の切り替えはファイルの有無**。止めたいならファイルを消すか外へ出す

発火したかは `herdr plugin log list --plugin cloudmanic.herdr-plus` で確認できる。

このディレクトリは nput 管理下（dotfiles の実体への symlink）なので、
ファイルを足せば即反映される。
