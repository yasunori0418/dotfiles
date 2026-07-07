# 失敗時の復旧手順

前提: `git reset` を伴う復旧は本スキルでは実行しない。**reset-flow スキル**の
ワークフロー（計画提示 → 承認 → arm → 実行）に委ねる。cchook guard も
reset-flow を通らない `git reset` をブロックする。

## 早見表

| 状況 | 対処 |
|---|---|
| rebase 進行中（コンフリクト等で停止） | `git rebase --abort` — 開始前の状態へ完全復帰（常時許可） |
| rebase 完了したが結果が想定と違う | backup へ巻き戻し — reset-flow スキルで `git reset --hard <backup>` |
| backup が無い / 消した | reflog から開始前 HEAD を特定 → reset-flow で reset |
| force-push 後に戻したい | ローカルを backup へ戻して再 force-push（下記） |
| 他者が rebase 後の履歴を pull 済み | 技術対応より先に関係者へ連絡。復旧 push はさらなる履歴書き換え |

## 各論

### rebase 進行中の状態確認

```bash
git status
git rebase --show-current-patch                                  # 今適用中のコミット
tail -5 "$(git rev-parse --git-path rebase-merge/done)"          # 消化済み todo
```

### abort

`git rebase --abort` は rebase 開始時点へ戻す（working tree ごと）。中断後は
rebase-context.sh を再実行して状態を確認してから仕切り直す。

### 完了後の巻き戻し（backup あり）

reset-flow スキルを起動し、target に backup ブランチを指定する:

```bash
# reset-flow のワークフロー内で実行される
git reset --hard <backup-branch>
```

### reflog からの復旧（backup が無い場合）

```bash
git reflog --date=iso | head -30
```

`rebase (start)` の 1 つ前のエントリが開始前 HEAD。その SHA を target として
reset-flow で reset する。reflog の既定保持期間は 90 日 — すぐ消えはしないが、
backup ブランチが第一の復旧手段であり、reflog は最後の頼みにしない。

### force-push 後の巻き戻し

1. `git fetch <remote> <branch>`
2. リモート tip が「自分が push した rebase 後 HEAD」のままか確認する
   （他者 push が挟まっていないか）:
   ```bash
   git rev-parse <remote>/<branch>   # rebase 後の HEAD と一致するか
   ```
3. 一致 → reset-flow で backup へ戻した後、gh-push スキルで force push:
   ```bash
   bash <gh-push skill>/scripts/gh-push.sh push <branch> --force --expect=<rebase後HEADのsha>
   ```
   （raw の `git push --force*` は cchook guard に弾かれる）
4. 不一致（他者 push あり）→ 停止し、ユーザー・関係者への連絡を優先する

### あてにしないもの

- `ORIG_HEAD` — merge / reset 等でも上書きされる。backup ブランチを使う
- reflog の無期限残存 — expire / gc で消え得る
