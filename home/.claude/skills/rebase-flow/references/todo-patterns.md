# interactive rebase の非対話 todo レシピ

エディタが開くと Claude Code セッションはハングする。todo とコミットメッセージは
すべてファイル・コマンドライン経由で与える。ここに無いパターンをアドリブで組まず、
計画テンプレに todo 全文を載せて承認を得たものだけを実行する。

## 基本形

1. todo を scratchpad のファイルに書く（例: `<scratchpad>/rebase-todo`）
2. 計画に todo 全文を掲載して承認を得る
3. 実行:

```bash
GIT_SEQUENCE_EDITOR="cp <scratchpad>/rebase-todo" git rebase -i <base-ref>
```

- todo の行順は「**古いコミットが先頭**」。`git log`（rebase-context.sh の REWRITE RANGE 出力も）は新しい順なので、反転して組む
- SHA は rebase-context.sh の出力からコピーする（打ち間違い防止）

## メッセージ変更は exec + `--amend -m` で行う

`reword` / `squash` はメッセージ編集のためにエディタを開く。`GIT_EDITOR=true` で
握りつぶすと意図しないメッセージが確定する。**メッセージを変えないコマンド
（pick / fixup / drop）+ exec だけ**で todo を構成する:

### reword（メッセージだけ変更）

```
pick abc1234 古いメッセージ
exec git commit --amend -m 'feat(x): 新しいメッセージ'
```

### squash 相当（複数コミットを 1 つに + 新メッセージ）

```
pick abc1234 1つ目
fixup def5678 2つ目
fixup 9012abc 3つ目
exec git commit --amend -m 'feat(x): まとめ後のメッセージ'
```

- `fixup` は後続コミットのメッセージを捨てる（エディタが開かない）
- 先頭コミットのメッセージをそのまま使うなら exec 行は不要
- `fixup -C <sha>` は fixup 対象側のメッセージを採用する（これもエディタ不要）
- body 付きメッセージは `-m '件名' -m '本文'`

### drop

```
drop abc1234 消すコミット
```

行の削除でも同じだが、明示的に `drop` と書く（承認時に意図が見える）。
drop すると §5 の tree 同一性は不一致になる — 計画にその旨を書く。

### 並べ替え

pick 行の順序を入れ替える。**並べ替えはコンフリクトを生み得る**
（context スクリプトの CONFLICT PREDICTION は onto 型専用で、これを予測しない）。
計画のコンフリクト予測欄に「並べ替えによる衝突の可能性あり」と書く。

### autosquash（commit-flow の fixup! コミット運用と併用する場合）

`--autosquash` に todo 生成を任せると、承認した todo と実際に走る todo がズレ得る。
`git rebase -i --autosquash` は使わず、fixup! コミットも上記の明示 todo で畳む。

## 注意

- `exec` はその直前の todo 行の適用後に実行される
- 範囲内にマージコミットがある場合はこのレシピを使わない（context スクリプトの
  WARNING 参照。`--rebase-merges` が要る履歴はユーザーと個別に設計する）
- コンフリクトで停止したら `git add <解消ファイル>` → `GIT_EDITOR=true git rebase --continue`
- メッセージは commit-flow スキル（Conventional Commits）準拠
