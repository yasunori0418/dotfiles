---
name: gh-push
description: "非対話セッション（claude-code の remote-control / CI など TTY が無く SSH 鍵パスフレーズを入力できない状況）で git push を通すスキル。remote が SSH URL（git@github.com:…）で秘密鍵がパスフレーズ保護されている、または ssh-agent に鍵が無いために `git push` が `Permission denied (publickey)` で失敗する場合に、push を HTTPS + gh トークン（credential.helper='!gh auth git-credential'）経由へ切り替えて標準入力なしで実行する。「push して」「リモートに反映して」と頼まれたが SSH 認証が使えない、push が publickey で弾かれた、remote-control から push したい、といった場面で使う。`/gh-push` で明示起動も可。GitHub(gh) 前提。"
argument-hint: "[push 先ブランチ名（任意、省略時は現在のブランチ）]"
---

# gh-push — gh トークン経由の非対話 push

## このスキルの目的

SSH 鍵がパスフレーズ保護されていて非対話セッションでは署名できない（標準入力が無く push が `publickey` で失敗する）状況でも、`git push` を通す。仕組みは1つ — **push 認証を gh の credential helper に肩代わりさせ、HTTPS で送る**:

```
git -c credential.helper= -c credential.helper='!gh auth git-credential' push <https-url> <branch>
```

`credential.helper=`（空）で既存ヘルパー一覧をリセットし、gh ヘルパーだけを使う。これで `cache`/`oauth` 等の介入を避ける。remote が SSH URL でも、URL を HTTPS に変換して push 先に使うので **origin の設定は変更しない**。

## 前提

- `gh auth status` でログイン済みで、トークンに **`repo`（write）scope** があること。無ければ push は権限エラーで落ちる（`gh auth refresh -s repo` で付与）。
- GitHub（github.com / GitHub Enterprise）が対象。GitLab 等 gh が扱わないホストは対象外 — その場合はこのスキルを使わず、SSH 鍵や glab を案内する。

## ワークフロー

判定・URL 変換・push 範囲算出・push 実行はすべて決定論的なので、git コマンドを手で並べ直さず `scripts/gh-push.sh` を使う。

### 1. preflight（push 対象を収集して提示）

```bash
bash <skill-dir>/scripts/gh-push.sh preflight [branch]
```

`=== SECTION ===` 区切りの出力を読み、**push 先 URL・ブランチ・送るコミット**をユーザーに提示する。`STATE` の意味:

- `up-to-date` … 差分なし。push 不要。
- `new` … リモートに無い新規ブランチ。直近コミットを提示。
- `fast-forward` … 通常 push 可。送るコミット一覧が出る。
- `diverged` … **履歴分岐**。通常 push は弾かれる。WARNING を読み、**ここで停止してユーザーに確認**（fetch して rebase/merge で整合させるのが既定。意図的な上書きのときだけ force）。
- `unknown` … リモート tip がローカルに無く厳密判定不能。非 FF ならサーバが安全に拒否するのでそのまま push 試行してよい。

`AUTH` セクションで gh 認証ホスト／アカウントを確認する。preflight が `ERROR:` を出したら、その内容（未認証・未対応 URL・detached HEAD 等）を解決してから進む。

### 2. push 実行

起動＝push 意図とみなし、preflight 提示後そのまま実行する（毎回の yes/no は取らない）。ただし上記 `diverged`（force が要る状況）だけは**必ず停止して確認**する。

```bash
bash <skill-dir>/scripts/gh-push.sh push [branch]
```

意図的な上書きをユーザーが承認した場合のみ force を付ける:

```bash
bash <skill-dir>/scripts/gh-push.sh push [branch] --force [--expect=<sha>]
```

force は `--force-with-lease=<branch>:<現リモート tip>` の**明示 lease** で実行される（URL 直 push では引数なし `--force-with-lease` の比較対象となる remote-tracking ref が参照されず、常に stale info で拒否されるため）。呼び出し元が「安全と確認済みのリモート tip」を持っている場合 — rebase-flow スキルからの委譲等 — は `--expect=<sha>` で渡す。確認時点以降に他者の push が挟まると実 tip と不一致になり、push 前に確実に停止する。

push 成功後、スクリプトは `refs/remotes/<remote>/<branch>` を手で進めて `git status` の ahead 表示を整合させる。

## 制約

- **force はユーザーの明示承認が無い限り付けない**。`diverged` 検出時は停止が既定。
- **保護ブランチへの force は script が拒否する**（静的リスト main/master/develop/trunk/release 等 + origin/HEAD + GitHub 既定ブランチ）。force が許されるのは作業ブランチのみ。
- このスキルは push そのものが目的なので、起動された時点では実行してよい（pr-create の「自動 push 禁止」とは役割が別）。ただし push 先が `main`/`master` など保護ブランチのときは、送るコミットを提示した上で一言断ってから実行する。
- remote URL や push 先ブランチが曖昧・複数候補ありうるときは、憶測で push せずユーザーに確認する。
