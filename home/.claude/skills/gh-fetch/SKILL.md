---
name: gh-fetch
description: "非対話セッション（claude-code の remote-control / CI など TTY が無く SSH 鍵パスフレーズを入力できない状況）で git fetch / pull を通すスキル。remote が SSH URL（git@github.com:…）で秘密鍵がパスフレーズ保護されている、または ssh-agent に鍵が無いために `git fetch`/`git pull` が `Permission denied (publickey)` で失敗する場合に、取り込みを HTTPS + gh トークン（credential.helper='!gh auth git-credential'）経由へ切り替えて標準入力なしで実行する。「fetch して」「pull して」「リモートの変更を取り込んで」「最新を取ってきて」と頼まれたが SSH 認証が使えない、fetch/pull が publickey で弾かれた、remote-control からリモートの更新を取り込みたい、といった場面で使う。gh-push の取り込み（incoming）版。`/gh-fetch` で明示起動も可。GitHub(gh) 前提。"
argument-hint: "[ブランチ名（任意、省略時は現在のブランチ）] [--merge|--rebase（pull 時のみ）]"
---

# gh-fetch — gh トークン経由の非対話 fetch / pull

## このスキルの目的

SSH 鍵がパスフレーズ保護されていて非対話セッションでは署名できない（標準入力が無く fetch/pull が `publickey` で失敗する）状況でも、リモートの変更を取り込む。仕組みは [[gh-push]] と同一 — **通信認証を gh の credential helper に肩代わりさせ、HTTPS で取得する**:

```
git -c credential.helper= -c credential.helper='!gh auth git-credential' fetch <https-url> +refs/heads/<branch>:refs/remotes/<remote>/<branch>
```

`credential.helper=`（空）で既存ヘルパー一覧をリセットし、gh ヘルパーだけを使う。remote が SSH URL でも URL を HTTPS に変換して取得元に使うので **origin の設定は変更しない**。public リポジトリならトークン無しでも HTTPS 変換だけで通る（gh helper は private のとき効く）。

## fetch と pull の違い（重要）

push と違い、取り込みは2段階で危険度が分かれる:

- **fetch** … remote-tracking ref を更新し object を取得するだけ。**作業ツリーを一切触らないので常に安全**。
- **pull** … fetch + 作業ブランチへの統合（merge/rebase）。**作業ツリーを書き換える**。未コミット変更との競合・コンフリクトが起きうる。

この性質差ゆえ、既定の統合戦略は **`--ff-only`（fast-forward のみ）** にしてある。最も多い「ローカルが clean でリモートに追従しているだけ」のケースをコンフリクト無しで取り込み、履歴が分岐している場合は作業ツリーを触らずに**明示的に停止**して戦略選択をユーザーに委ねる。これは gh-push が `diverged` で停止するのと同じ思想。

## 前提

- `gh auth status` でログイン済みであること。private リポジトリの取得にはトークンの read 権限が要る（public は不要）。
- GitHub（github.com / GitHub Enterprise）が対象。GitLab 等 gh が扱わないホストは対象外 — その場合はこのスキルを使わず SSH 鍵や glab を案内する。

## ワークフロー

判定・URL 変換・状態算出・取り込み実行はすべて決定論的なので、git コマンドを手で並べ直さず `scripts/gh-fetch.sh` を使う。

### 1. preflight（取り込み対象を収集して提示）

```bash
bash <skill-dir>/scripts/gh-fetch.sh preflight [branch]
```

`=== SECTION ===` 区切りの出力を読み、**取得元 URL・ブランチ・取り込まれるコミット・作業ツリーの状態**をユーザーに提示する。`STATE` の `incoming` の意味:

- `up-to-date` … リモート tip を既に保持。取り込み不要。
- `behind` … ローカルがリモートの祖先。**FF で安全に取り込める**。取り込まれるコミット一覧が出る。
- `diverged` … **履歴分岐**。FF 不可。pull には `--merge` / `--rebase` が要る。**ここで停止してユーザーに確認**（rebase か merge か、そもそも取り込むか）。
- `fetchable` … リモートに新規コミットがあるが未取得で件数不明。fetch すれば確定する。
- `missing-remote` … リモートにそのブランチが無い。取り込むものがない。

`WORKTREE` セクションで dirty / clean を確認する。dirty のとき pull は実行できない（fetch は可）。preflight が `ERROR:` を出したら、その内容（未認証・未対応 URL・detached HEAD 等）を解決してから進む。

### 2. 実行

意図に応じて使い分ける:

**fetch のみ**（作業ツリーを触らず ref と object だけ更新したいとき。常に安全）:

```bash
bash <skill-dir>/scripts/gh-fetch.sh fetch [branch]
```

実行後、未取り込みコミット件数と一覧を出す。

**pull**（作業ブランチへ統合まで行う）:

```bash
bash <skill-dir>/scripts/gh-fetch.sh pull [branch]              # 既定 = --ff-only
bash <skill-dir>/scripts/gh-fetch.sh pull [branch] --merge      # ユーザー承認後のみ
bash <skill-dir>/scripts/gh-fetch.sh pull [branch] --rebase     # ユーザー承認後のみ
```

起動＝取り込み意図とみなし、preflight 提示後そのまま実行してよい。ただし:

- **作業ツリーが dirty なら pull は走らない**（スクリプトが停止）。先に commit / stash をユーザーに促す。
- **`diverged`（FF 不可）で `--merge`/`--rebase` を付けるのは、必ずユーザー確認後**。既定の `--ff-only` は分岐時に作業ツリーを触らず安全に失敗する。
- 統合中にコンフリクトが出たら、スクリプトは**中止せず**コンフリクトファイルを提示して停止する。作業ツリーは統合途中の状態で残るので、ユーザーが解決（`git rebase --continue` / `git commit`）か中止（`--abort`）を選べる。

## 制約

- **`--merge` / `--rebase` はユーザーの明示承認が無い限り付けない**。既定は `--ff-only`、分岐検出時は停止が既定。
- このスキルは取り込みが目的なので、起動された時点で fetch は実行してよい。pull で作業ツリーを書き換える前は、取り込まれる内容を提示した上で一言断る。
- remote URL や対象ブランチが曖昧・複数候補ありうるときは、憶測で取り込まず確認する。
