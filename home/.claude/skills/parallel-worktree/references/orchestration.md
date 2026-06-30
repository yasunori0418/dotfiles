# orchestration リファレンス

`parallel-worktree` スキルの具体手順。依存解析の判断基準、`wt`/tmux/`gh` のコマンドレシピ、タスクプロンプト雛形をまとめる。

> **正本は `scripts/plan_orchestration.py`。** 起動ウェーブ順・base 解決・コマンド列の生成は決定論スクリプトが出力する（`uv run --project <SKILL> python <SKILL>/scripts/plan_orchestration.py <spec.json>`）。本ドキュメントは「そのコマンドが何をしているか」の解説と、スクリプトを使わない場合のフォールバックとして読む。順序・base・クォートをここから手作業で再構成しない。

## 目次

- [依存解析](#依存解析) — 並列にしてよいか stacked にすべきかの見分け
- [worktree 作成](#worktree-作成) — 独立 / stacked それぞれの `wt` コマンド
- [tmux でエージェント起動](#tmux-でエージェント起動) — agent handoff の起動コマンド
- [タスクプロンプト雛形](#タスクプロンプト雛形) — 各エージェントに渡す指示
- [PR 作成](#pr-作成) — `/pr-create` 連携と base 指定
- [監視・後始末](#監視後始末) — `wt list` / `wt merge` / `wt remove`

## 依存解析

2 つのタスクを **並列にしてよい（独立）** か **stacked にすべき（依存）** かは、次で判断する。

**依存あり（stacked / 逐次にする）と判断する材料:**

- 後段が前段で追加・変更する**型・関数・クラス・API・DB スキーマ・設定**を参照する
- 同一ファイル、または密結合した同一モジュールを両方が編集する（コンフリクト確実）
- 後段の動作確認に前段の実装が前提になる
- 「まず基盤を入れてから、その上に機能を載せる」構造

**独立（並列にしてよい）と判断する材料:**

- 触るファイル/ディレクトリ/モジュールが重ならない
- 共有するのは安定済みの既存 API のみで、互いの新規変更に依存しない
- 別々の機能・別々のレイヤーで、マージ順がどちらでも成立する

判断に迷う組み合わせは独立扱いにせず、**ユーザーに確認する**（grill-me 方式）。並列で走らせてから依存が発覚すると手戻りが大きい。

stacked が 3 段以上になるときは、本当に全段が連鎖依存か見直す。途中に独立な段が混ざるなら、そこは別の並列グループに切り出せる。

## worktree 作成

worktree は必ず `wt` で作る（post-start hook で direnv/symlink が整う）。

**独立タスク**（base はデフォルトブランチ）:

```bash
wt switch --create feat-foo      # main から feat-foo の worktree を作成
wt switch --create feat-bar      # main から feat-bar の worktree を作成
```

**stacked**（前段ブランチを base にする。前段がコミット済みになってから後段を切る）:

```bash
# 1段目を作って実装・コミットを済ませる
wt switch --create stack-base
# （stack-base で実装・コミット完了後）
# 2段目を 1段目から分岐
wt switch --create stack-2 --base stack-base
# 3段目を 2段目から分岐
wt switch --create stack-3 --base stack-2
```

`--base` のショートカット: `--base=@`（現 HEAD から）、`--base=pr:123`（PR #123 の head から）。

worktree のパスは user config の `worktree-path` テンプレートで決まる（このリポジトリでは `{{ repo_path }}/../{{ repo }}.{{ branch | sanitize }}`）。パスを知るには `wt list` で確認する。

## tmux でエージェント起動

worktrunk の agent handoff パターン。`wt switch -x claude` で worktree 切替後にその worktree 内で本物の claude を起動する（`-x` は wt プロセスを claude に置き換え、端末制御を渡す）。detached tmux セッションに入れることでバックグラウンド並列になる。

**独立タスク群（同時に起動してよい）:**

```bash
tmux new-session -d -s feat-foo "wt switch --create feat-foo -x claude -- '<タスクプロンプト>'"
tmux new-session -d -s feat-bar "wt switch --create feat-bar -x claude -- '<タスクプロンプト>'"
```

- `-d` で detached 起動。`-s <name>` はブランチ名（sanitize 済み）に揃えると `wt list` と対応が取れて追いやすい
- `--` 以降がプロンプトとして claude に渡る（`wt switch feature -- 'Fix #322'` → `claude 'Fix #322'`）

**Remote Control 付き起動（`--remote-control` 指定時）:**

detached tmux に入ったままでも claude.ai 等からリモート接続したいときは、claude を `--remote-control <名前>` で起動する。`-x claude` の `--` 以降は順にコマンドへ追記されるので、**名前 → プロンプトの順**で渡す。

```bash
tmux new-session -d -s feat-foo "wt switch --create feat-foo -x claude -- --remote-control feat-foo '<タスクプロンプト>'"
```

- `claude --remote-control <名前> '<プロンプト>'` になる。`--remote-control` の名前は省略可能だが、省略すると後続のプロンプトを名前として誤食いするため、**常に名前を明示する**。
- 名前は tmux セッション名（sanitize 済みブランチ名）に揃え、`tmux ls` / `wt list` / リモート一覧で同じ識別子で対応を取る。
- このコマンド列は `plan_orchestration.py --remote-control` が生成する（手作業で組み立てない）。

**stacked（逐次。前段の実装・コミットを待ってから次段を起動）:**

1段目を起動 → 完了（実装・コミット）を `wt list` 等で確認 → 2段目を `--base <前段ブランチ>` 付きで起動、を繰り返す。前段がコミットされる前に後段を切ると、後段が前段のコードを見られない。

セッションへの接続は `tmux attach -t <name>`、一覧は `tmux ls`。

## タスクプロンプト雛形

各エージェントに渡すプロンプトには、最低限これを含める。境界を明示しないと他タスクの領域に踏み込んでコンフリクトする。

```
<タスクの具体的な内容と完了条件>

## 制約
- 編集してよい範囲: <ファイル/ディレクトリ/モジュールを明示>。これ以外には触れない
- コミット: 論理的に独立した修正は都度コミットする（commit-flow スキル準拠、Conventional Commits）
- push: 自分の feature ブランチ <branch> に限り push してよい。main 等の保護ブランチへは push しない
- 完了後: `/pr-create <base>` を実行して draft PR を作る
  - 独立タスク: <base> はデフォルトブランチ（省略可）
  - stacked: <base> は前段ブランチ名
```

## PR 作成

各エージェントが実装・コミット完了後、自分で `/pr-create [base]` を実行する。

- `/pr-create` は draft 既定・タイトル/本文をユーザー承認後に作成・自動 push 禁止。各 tmux pane で承認/push のゲートに到達して停止するので、ユーザーが pane を巡回して進める
- push: エージェントは自分の feature ブランチを push してよい（PR 作成に必要なため）。保護ブランチは不可
- stacked: `/pr-create <parent-branch>` で base を前段に向ける。GitHub 上で stacked PR の依存が表現される

## 監視・後始末

- **進捗確認**: `wt list`（worktree 一覧・状態）。詳細は `wt list --full`（CI・diffstat・LLM 要約）
- **マージ**: `wt merge [target]`（current ブランチを target に squash & rebase してマージ、worktree 削除まで）。ただしローカル merge は PR レビューを飛ばすので、PR 運用中は GitHub 側マージを基本にする
- **後始末**: `wt remove`（worktree 削除、マージ済みならブランチも削除）
- **stacked の再 rebase**: 下段が変わったら上段を rebase する必要がある。`wt merge --rebase` か手動 `git rebase`。この環境に `wt sync`（worktrunk-sync）は無いので自動 restack は使えない
