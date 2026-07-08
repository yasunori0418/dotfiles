---
name: parallel-worktree
description: "計画ファイルを読み、worktrunk(wt) で worktree を分けて並列・stacked に実装を進めるオーケストレーション。独立タスクは tmux の独立 claude で並列実行、依存連鎖は stacked PR として逐次構築する。`--remote-control` 指定で各 worktree の claude を Remote Control 付きで起動し、detached tmux のまま claude.ai 等からリモート接続できる。`--model`/`--permission-mode`/`--effort` で各 claude の起動モデル・パーミッションモード・effort を切り替えられる（task 個別上書きも可）。`/parallel-worktree resume` でPCの強制終了・クラッシュ等による不意の中断後、全レーン（worktree）の未コミット・未push状態と対応する計画ファイルを機械的に一覧化する復旧モードにもなる。`/parallel-worktree [計画ファイル|resume] [オプション...]` の明示実行専用。"
user-invocable: true
disable-model-invocation: true
argument-hint: "resume | [計画ファイルのパス] [--remote-control] [--model <model>] [--permission-mode <mode>] [--effort <level>]"
allowed-tools: Bash, Read, AskUserQuestion, ExitPlanMode
---

# parallel-worktree

大量のサブエージェント起動・worktree 生成・push という外部影響の大きい操作を含むため、`disable-model-invocation: true` とし `/parallel-worktree` の明示実行時のみ動作する。

## 起動引数

`/parallel-worktree resume` — **クラッシュ復旧モード**（下記セクション参照）。第一引数が `resume` のときはこちらに分岐し、Phase 0 以降の通常オーケストレーションには進まない。

`/parallel-worktree [計画ファイルのパス] [--remote-control] [--model <model>] [--permission-mode <mode>] [--effort <level>]` — 通常のオーケストレーション起動。

- **計画ファイルのパス**: 事前に作成済みの計画ファイル（無ければ所在をユーザーに確認）。
- **`--remote-control`**（任意・オプトイン）: 起動引数にこのトークンが含まれていたら、Phase 1 の `plan_orchestration.py` 実行にそのまま `--remote-control` を渡す。各 worktree の claude が `--remote-control <ブランチ名>` で起動し、**detached tmux に入ったままでも claude.ai 等からリモート接続できる**（この親セッションと同じ Remote Control 接続方式）。Remote Control 名は tmux セッション名（sanitize 済みブランチ名）に揃うので、`tmux ls` / `wt list` / リモート一覧で同じ識別子で対応が取れる。無指定なら従来通りローカル tmux のみ（リモート登録しない）。
- **`--model <model>` / `--permission-mode <mode>` / `--effort <level>`**（任意）: 各 worktree の claude の起動既定。起動引数にあれば Phase 1 の `plan_orchestration.py` 実行へそのまま渡す（値ごと pass-through）。
  - `--model`: alias（`opus`/`sonnet`/`fable` 等）またはフルネーム
  - `--permission-mode`: `acceptEdits` / `auto` / `bypassPermissions` / `manual` / `dontAsk` / `plan`
  - `--effort`: `low` / `medium` / `high` / `xhigh` / `max`
  - 適用は **task 個別指定（spec の `model`/`permission_mode`/`effort`）> グローバル既定（このフラグ）> 未指定（claude 自身のデフォルト＝settings.json 等）** の優先順。タスクごとに変えたい場合は spec 側に書く。

## クラッシュ復旧モード（`/parallel-worktree resume`）

PC の強制終了・クラッシュ等でセッションが不意に中断されたときのための read-only モード。並列・stacked で複数 worktree（レーン）を動かしている最中に落ちると、レーンの数だけ「どこまで終わっていたか」を手動で説明し直す必要が出るため、`wt list` を土台に全レーンの状態を一度に機械的に集計する。

新しい worktree・tmux・エージェントは一切起動しない（Phase 2 には進まない）。**能動的な引き継ぎ用の `handoff` スキル（一部プロジェクトに導入済み）とは補完関係**: `handoff` はセッションを意図的に終える前に自分で書く前提のドキュメントで、不意打ちのクラッシュには使えない。`resume` は逆に、事前準備が無い不意の中断からの受け身の状況復元に使う。

手順:

1. `uv run --project "<SKILL>" python "<SKILL>/scripts/resume_check.py"` を実行する（`-C <path>` で対象リポジトリを指定可、既定は cwd）。内部で `wt list --format json` を呼び、レーンごとの `branch` / `path` / 未コミット変更（`dirty`） / 未push件数（`ahead`）/ 未pull件数（`behind`）を集計し、ブランチ名から `~/.claude/plans/`（既定。`--plans-dir` で変更可）内の対応しそうな計画ファイルも突き合わせる。
2. 出力の `NEEDS ACTION` に挙がったレーン（`dirty=True` または `ahead>0`）を優先して、レーンごとに次アクション（`git status`/`git diff` で中身を確認 → 必要なら `/gh-push` や `/pr-create [base]`、または実装の続行）をユーザーに提示する。plan_candidates が見つかったレーンはその計画ファイルを読み、残タスクの位置を特定する材料にする。
3. 複数レーンにまたがる作業がある場合、**憶測でまとめて処理せず、レーンごとにユーザーへ状況を要約してから次の対応を確認する**（各レーンの文脈は独立しているため）。

## 前提と本質的な制約

着手前にこの 3 点を頭に入れる。設計判断の根拠になる。

1. **並列と stacked は相反する。** 並列＝タスク間が独立（同時に走らせられる）。stacked＝後段が前段のコードに依存する連鎖（前段がコミットされて初めて後段を切れる）。だから「全部まとめて並列 background」は stacked では成立しない。**独立タスク群は並列、依存連鎖は逐次** に振り分けるのがこのスキルの肝。

2. **worktree は必ず `wt` で作る。** Claude の `isolation: "worktree"` は使わない。`wt switch --create` で作れば post-start hook が走り、gitignored の symlink 化・`direnv allow` まで済んでビルド可能な実環境になる。hook の走らない worktree でエージェントを動かすと、direnv/依存が無くビルド・テストが通らない事故になる。

3. **`wt` は PR を作らない／stacked branch もネイティブ非対応。** stacked は「`wt switch --create <child> --base <parent>` でブランチを積む」＋「PR は `gh`（`/pr-create` スキル）で `--base <parent>` 指定」の合わせ技で実現する。

## 決定論ツール（scripts/）と AI の責務分担

このスキルは「意味理解が要る部分（AI）」と「機械的に確定できる部分（スクリプト）」を分ける。**AI の責務は計画ファイルから「タスクと依存辺」を読み取り JSON spec を組むところまで**。そこから先の環境前提収集・スケジュール算出・コマンド生成は決定論スクリプトに委譲し、再発明と順序ミスを防ぐ。

スクリプトは Python プロジェクト（`pyproject.toml` + `uv.lock`）として梱包され、`uv` が `requires-python` に沿った `.venv` を skill ディレクトリ直下に構築して実行する。cwd 非依存なので、プラグインとして任意の環境へ配置しても動く。以下、skill 本体のパスを `<SKILL>` と表記する（プラグイン実行時は `${CLAUDE_PLUGIN_ROOT}/skills/parallel-worktree`、個人 skill 実行時はこの SKILL.md があるディレクトリ）。

- **`scripts/preflight.sh`**（read-only）: `wt`/`gh`/`tmux` 有無・既定ブランチ・**未コミット変更**・既存 worktree/ブランチ名衝突を収集。`bash <SKILL>/scripts/preflight.sh` を実行し、`WARNING` を解消してから起動に進む。
- **`scripts/plan_orchestration.py`**: AI が組んだ JSON spec を入力に、**循環検出・base 解決・並列ウェーブ算出・wt/tmux//pr-create コマンド列生成**を行う。実行は必ず `.venv` 経由:

  ```bash
  uv run --project "<SKILL>" python "<SKILL>/scripts/plan_orchestration.py" <spec.json>
  # 起動引数のオプションはそのまま前に付ける（--remote-control / --model / --permission-mode / --effort）:
  uv run --project "<SKILL>" python "<SKILL>/scripts/plan_orchestration.py" --remote-control --model opus --permission-mode acceptEdits --effort high <spec.json>
  ```

  spec の形（`scripts/example-spec.json` 参照）:

  ```json
  {
    "default_base": "main",
    "tasks": [
      {"id": "A",  "branch": "refactor-logger",  "depends_on": [],     "prompt": "..."},
      {"id": "B2", "branch": "feat-client-retry", "depends_on": ["B1"], "prompt": "...",
       "model": "opus", "permission_mode": "plan", "effort": "high"}
    ]
  }
  ```

  `depends_on` 空＝独立（並列・base はデフォルト）、親 1 つ＝その親ブランチを base にした stacked 段。task の `model`/`permission_mode`/`effort` は任意で、その task の claude だけ起動設定を上書きする（CLI のグローバル既定より優先。どちらも無ければ claude 自身のデフォルト）。出力の `SCHEDULE`（起動ウェーブ）と `COMMANDS`（実行コマンド列）をそのまま plan と実行に使う。スクリプトのロジック（順序・base・クォート）は SKILL.md 上で再現しない。

## 全体フロー

### Phase 0: 計画ファイルを読み、spec を組む

入口は**事前に作成済みの計画ファイル**（引数のパス。無ければ所在をユーザーに確認）を読むこと。計画は別途 grill-me 方式（対話的な問い詰め）で固めてファイル化されている前提。

読み込んだら、各タスクの **依存辺（A→B）** を意味的に判定し、上記 JSON spec に落とす。判定基準（同一ファイル/モジュールに触る、前段の型・関数・API・スキーマに依存する 等）は `references/orchestration.md` の「依存解析」を参照。**計画ファイルに依存関係やタスク境界が欠けている／曖昧なときは、憶測で埋めず grill-me 方式で確認する**（依存の読み違えは並列化を破綻させる）。

### Phase 1: 事前確認・スケジュール算出 → plan 承認

1. `bash <SKILL>/scripts/preflight.sh` を実行。`WARNING`（未コミット変更・ツール欠落・名前衝突）があれば先に解消する。
2. `uv run --project "<SKILL>" python "<SKILL>/scripts/plan_orchestration.py" <spec.json>` でスケジュール／コマンド列を算出。`ERROR`（循環・未定義参照・重複・不正な permission_mode/effort）が出たら spec を直して再実行。**起動引数に `--remote-control` / `--model` / `--permission-mode` / `--effort` があればこのコマンドにもそのまま付ける**（生成される tmux コマンドの claude にそのフラグが乗る）。
3. その出力を土台に **plan を組み、`ExitPlanMode` で承認を取る**。plan には必ず含める:
   - **振り分け表 / 起動ウェーブ**（スクリプトの `SCHEDULE`）
   - **コミット計画**: `commit-flow` スキル準拠（plan 本文に必ず含める）
   - **PR 戦略**: 各ブランチの base（スクリプトの `PR` セクション）

承認なしで worktree 生成・エージェント起動に進まない。

### Phase 2: worktree 作成・並列/stacked 起動

承認後、スクリプトの `COMMANDS` をウェーブ順に実行する。コマンドの意味は `references/orchestration.md` を参照。

- **wave 0（独立）**: まとめて並列起動してよい
- **後続 wave（stacked）**: 前段の**コミット完了を `wt list` で確認してから**起動（後段が前段のコードを見られるように）

各エージェントへ渡すプロンプトには必ず「実装範囲の境界（他タスクのファイルに触れない）」「コミット粒度（commit-flow 準拠）」「自分の feature ブランチを push してよい」「最後に `/pr-create [base]` を実行」を含める（spec の `prompt` に書く）。worktree は必ず `wt switch --create` で作り、`isolation: "worktree"` は使わない。

### Phase 3: PR 作成

各エージェントが実装・コミット完了後、**自分で `/pr-create [base]` を実行**して draft PR を作る（スクリプトの `PR` セクション通り）。

- push ポリシー: エージェントは**自分の feature ブランチに限り push 可**。`main` 等の保護ブランチへは push しない
- stacked: `/pr-create <parent-branch>` で base を前段に向ける
- `/pr-create` はタイトル/本文をユーザー承認後に作成する対話ゲートを持つ。各 tmux pane で承認待ちになるので、ユーザーが pane を巡回して承認する。**`--remote-control` 起動時は pane を巡回せず、claude.ai 等のリモート接続から各セッション（Remote Control 名＝ブランチ名）に入って承認できる**

### Phase 4: 監視・後始末

- 進捗確認: `wt list`（各 worktree の状態・diff・CI を一覧）
- マージ後: `wt remove` で worktree 削除（マージ済みブランチも削除）
- stacked の再 rebase: 下段が変わったら上段を rebase。`wt merge --rebase` か手動 `git rebase`（この環境に `wt sync`/worktrunk-sync は無い）

## 連携スキル・参照

このスキルは下記を**呼び出す側**で、内容を重複させない。

- `commit-flow`: コミット粒度と plan のコミット計画（Phase 1・各エージェント）
- `pr-create`: PR 本文作成（Phase 4 で各エージェントが `/pr-create` を実行）
- `worktrunk`: `wt` の設定・hook の詳細が要るとき
- `references/orchestration.md`: 依存解析ヒューリスティック、`wt`/tmux/`gh` コマンドレシピ、stacked 構築手順、タスクプロンプト雛形
