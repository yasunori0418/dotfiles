---
name: gh-ci-investigate
description: "GitHub Actions の CI 失敗を調査するスキル。失敗した run / PR / job の URL（例: https://github.com/OWNER/REPO/actions/runs/RUNID、…/pull/PR、…/job/JOBID）や run_id・PR 番号を貼られて「このCIが失敗している、原因を調査して」「ビルド/テストがコケた、なぜ落ちたか調べて」「workflow が failed、修正案を出して」「job のログを見て」と頼まれたら必ず使う。WebFetch では github.com のログは取れない（cchook が差し戻し、HTML しか返らない）ため、gh（`gh run view --log-failed` / `gh run view --job` / `gh pr checks` / `gh api`）で失敗ジョブ・ステップと失敗ステップのログだけを決定論スクリプトで収集し、失敗原因を特定して修正案を提示する。GitHub Actions 以外（GitLab CI 等）や、URL がログではなくソース閲覧目的のときは対象外。GitHub(gh) 前提。`/gh-ci-investigate` で明示起動も可。"
argument-hint: "[run/PR/job の URL・run_id・#PR番号（省略時は現在ブランチの最新 run）]"
---

# gh-ci-investigate — gh 経由の GitHub Actions 失敗調査

## このスキルの目的

CI 失敗調査で毎回同じことをする——失敗した run を開き、どのジョブ・ステップが落ちたかを見て、失敗ステップのログから原因を読む——を、決定論スクリプトに寄せて安定させる。

肝は **WebFetch を使わないこと**。github.com への WebFetch は cchook が差し戻すうえ、通っても Actions 画面の HTML が返るだけでログにならない。失敗ジョブ・ステップと「失敗ステップだけのログ」は `gh` で確実かつ簡潔に取れる。だから run/PR/job の URL を渡された時点で `scripts/gh-ci-investigate.sh` に解決させ、そこから調査に入る（グローバル CLAUDE.md の「GitHub 情報は gh で取得」ルールの具体実装）。

## 前提

- `gh auth status` でログイン済みであること。private リポジトリのログ取得にはトークンの read 権限が要る。
- 対象は GitHub（github.com / GitHub Enterprise）の **Actions**。GitLab CI 等 gh が扱わない CI は対象外——その場合はこのスキルを使わず該当 CLI を案内する。
- URL がソース閲覧・PR 差分の確認目的（失敗調査でない）なら、無理にこのスキルを通さず通常の gh / Read で足りる。

## ワークフロー

入力（URL / run_id / #PR / 空）の解釈、run の要約、失敗ログ取得はすべて決定論的なので、gh を手で並べ直さず `scripts/gh-ci-investigate.sh` を使う。`<skill-dir>` はこのファイルのあるディレクトリ。

### 1. preflight（何が落ちたかを掴む）

```bash
bash <skill-dir>/scripts/gh-ci-investigate.sh preflight "<url|run_id|#PR|（空=現在ブランチ最新）>"
```

`=== SECTION ===` 区切りで **対象 repo・認証状態・失敗ジョブとステップ・結論** が出る。ここでまず「どの workflow の・どのジョブの・どのステップが・どの結論（failure / cancelled / timed_out）で落ちたか」をユーザーに提示する。`ERROR:` が出たら（未認証・URL 不正・repo 特定不可など）先にそれを解決する。

PR URL / `#PR` を渡した場合は、その PR の checks 一覧と、失敗している check に対応する run の要約が出る。

### 2. logs（失敗ステップのログだけ取る）

```bash
bash <skill-dir>/scripts/gh-ci-investigate.sh logs "<url|run_id|#PR>" [--job <job_id>]
```

`gh run view --log-failed` で**失敗ステップのログだけ**を取る（full log ではないので context を食い潰さない）。特定ジョブに絞るときは job URL を渡すか `--job <id>` を付ける。run がまだ実行中でログ未確定のときは要約にフォールバックする。

ログが大量なときは、まず末尾やエラー行（`Error`, `FAIL`, `Exception`, `exit code`, `AssertionError`, スタックトレース）に当たりを付けてから該当箇所を精読する。

### 3. 原因特定とコード突き合わせ

ログで掴んだ失敗箇所を、リポジトリの該当コード・設定（テストコード、workflow yaml、依存定義など）と突き合わせて根本原因を絞る。必要なら該当ファイルを Read / Grep する。ログの時刻に言及するときは **JST** に直す。

### 4. 修正案の提示

原因と修正案をまとめて提示する。**修正はこのスキルの役割ではない**——コードやワークフローの変更はユーザーの承認を得てから、通常の編集フロー（必要なら commit-flow / pr-create）で行う。リリース PR やインフラ適用が絡むときは影響範囲を明示する。

## 出力の型

調査結果は次の順で簡潔にまとめる:

```
## 失敗の要約
- workflow / job / step / 結論（と run URL）
## 根本原因
- ログの該当行を最小限引用し、なぜ落ちたかを事実ベースで
## 修正案
- 具体的な変更点（ファイル・行）。複数案あるときは推奨を先頭に
```

## 制約

- **WebFetch で github.com を叩かない**。ログ・run 情報は必ず gh 経由。
- **修正の自動適用はしない**。原因特定と修正案の提示まで。変更はユーザー承認後に別途行う。
- private リポジトリや GitHub Enterprise で認証が通らないときは、`gh auth status` / `gh auth login --hostname <host>` を案内し、憶測で進めない。
- ログにトークン・認証情報・顧客データ様の文字列が含まれうる。引用は原因説明に必要な最小限にとどめ、秘匿様の文字列は伏せる。
- 関連スキル: リモートの取り込みは [[gh-fetch]]、push は [[gh-push]]。
