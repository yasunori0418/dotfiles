---
name: reset-flow
description: "git reset（HEAD / ブランチポインタの移動）の安全運用ルール。reset --hard は未コミット変更をどこにも残さず消せる唯一の日常操作であり、git reset を 1 つでも実行する前に必ず本スキルを参照する。「reset して」「巻き戻して」「直前のコミットを取り消して」「コミットをやり直したい」「変更を全部捨てて」「HEAD を◯◯に戻して」と依頼される、rebase-flow の失敗から backup へ復旧する、reflog から復元する、といった場面すべてが対象。決定論スクリプトで失われるもの（外れるコミット・push 済み範囲・消える未コミット変更）を判定 → 計画提示 → ユーザー承認 → safety branch 作成（arm）→ 実行 → 検証、のゲートを固定化する。cchook の guard により arm なしの git reset は機械的にブロックされる。unstage 目的なら reset ではなく git restore --staged を使う。"
user-invocable: true
argument-hint: "[target-ref と mode（例: backup/rebase/foo-20260707 hard）]"
---

# reset 安全運用

`git reset` は 2 つの破壊を同時に起こせる: **ブランチからコミットを外す**（reflog / backup があれば復旧可）と、`--hard` による**未コミット変更の完全消滅**（どこにも残らず復旧不能 — reset 最大の危険）。本スキルは **収集 → 計画提示 → 承認 → arm + 実行 → 検証** をゲートとして固定する。

環境側の強制: cchook の PreToolUse guard が `git reset` を監視しており、`scripts/reset-arm.sh` が置く解錠 marker（30 分有効）が無い実行は機械的に deny される。

## そもそも reset を使わない選択肢（先に検討する）

| やりたいこと | reset 不要の代替 |
|---|---|
| ステージを外す（unstage） | `git restore --staged <paths>`（guard 対象外・HEAD を動かさない） |
| ファイルの変更を捨てる | `git restore <paths>`（対象を限定できる） |
| 直前コミットの修正 | `git commit --amend`（rebase-flow / commit-flow の範疇） |
| push 済みコミットの取り消し | `git revert`（履歴を書き換えない） |

本スキルの対象は「HEAD / ブランチポインタを動かす reset」だけ。上記で足りるなら reset しない。

## 制約（厳守）

1. **承認なし実行禁止** — §2 の計画を提示し、ユーザーの明示承認を得るまで `git reset` を実行しない。
2. **arm なし実行禁止** — 承認後に `scripts/reset-arm.sh` で safety branch + 解錠 marker を作ってから実行する。
3. **BLOCKER で停止** — 保護ブランチ・detached HEAD・進行中操作（rebase 中の reset は `--abort` を使う）では計画に進まない。
4. **`--hard` × 未コミット変更は明示承認** — 消えるファイル一覧を計画に載せ、破棄が意図だと確認できた場合のみ `reset-arm.sh --allow-dirty`。確認できなければ実行しない。
5. **push 済みコミットを外す reset は force-push 前提を明示** — reset 後リモートと分岐する。リモート反映は rebase-flow §7 と同じ手順（明示 lease / gh-push `--expect`）。
6. **承認済みコマンドを一字一句そのまま実行** — mode（--hard/--mixed/--soft）を実行時に変えない。
7. **safety branch の削除はユーザー承認制**。ORIG_HEAD は他操作で上書きされるため復旧手段として当てにしない。

## ワークフロー

### 1. コンテキスト収集

```bash
bash <skill-dir>/scripts/reset-context.sh <target-ref> <hard|mixed|soft>
```

- **COMMITS LEAVING BRANCH** — ブランチから外れるコミット。push 済みが含まれる WARNING は制約 5 へ。
- **WORKING TREE** — `--hard` で消える未コミット変更。WARNING が出たら制約 4 へ。
- **TARGET の relationship** — 巻き戻し（ancestor）/ 前進（descendant）/ 乗り換え（divergent）。意図と一致するか確認する。

### 2. 計画提示（承認ゲート）

```markdown
## reset 計画: <目的を一言>

### 現在の状態
- ブランチ: `<branch>`（HEAD: `<sha7>`、safety 予定名: `backup/reset/<branch>-<ts>`）
- WARNING: <スクリプトの WARNING 全件。無ければ「なし」>

### reset が必要な理由
<目的。reset 以外で足りないことも一言>

### 実行するコマンド
git reset --<mode> <target-ref>

### 失われるもの / 残るもの
- ブランチから外れるコミット: <N 件（一覧）> → safety branch に残る
- 未コミット変更: <--hard: 消滅（一覧）/ それ以外: 保持>
- untracked・stash: 影響なし

### 期待される reset 後の状態
<HEAD がどこを指すか。git log の見え方>

### 復旧手段
- コミットの復旧: reset-flow で target=<safety branch>
- <--hard × dirty の場合: 未コミット変更は復旧不能>
```

軽量ケース（`--soft` / `--mixed` で外れるコミットも push 影響も無い場合）は「現在の状態・コマンド・影響」の 3 点に簡略化してよい。承認と arm は同じく必須。

### 3. 実行

1. `bash <skill-dir>/scripts/reset-arm.sh`（dirty 破棄の承認済み計画のみ `--allow-dirty`）
2. 承認済みコマンドをそのまま実行。

### 4. 検証と報告

1. `git rev-parse HEAD` が target と一致すること。
2. `git status --short` と `git log --oneline -5` で期待状態を確認。
3. marker を除去: `rm -f "$(git rev-parse --git-path reset-flow.armed)"`
4. response-format 準拠で報告: 実行コマンド / HEAD の移動（before → after）/ safety branch 名 / リモートとの関係（force-push が要るなら次の手順）。

## 参照

- `scripts/reset-context.sh` — 失われるもの・push 影響・dirty 判定の read-only 収集
- `scripts/reset-arm.sh` — safety branch 作成 + guard 解錠
- 関連スキル: rebase-flow（rebase 失敗からの復旧で本スキルが呼ばれる。force-push 手順は rebase-flow §7）/ gh-push（非対話環境の push 委譲）
