---
name: diff-review
description: 作業ブランチの diff を複数観点(レンズ)で並列レビューするオーケストレーションスキル。「レビューして」「diff をレビュー」「〇〇観点で見て」などユーザーが明示的にコードレビューを依頼したときに必ず使用する。決定論スクリプトで差分を収集し、レンズごとに diff-reviewer サブエージェントを並列起動して結果を統合報告する。コードの修正は行わない。
---

# diff-review: 並列多観点 diff レビュー

フローは 3 段階: **1. 差分収集(決定論)→ 2. レンズごとに diff-reviewer agent を並列起動 → 3. 統合報告**。
レビューは読み取り専用。修正・コミットはこのスキルの範囲外で、ユーザーの指示があってから別途行う。

## 1. 差分収集

`~/.claude/skills/diff-review/scripts/collect-diff.sh manifest [<base-ref>]` を実行する。

- 出力: レビュー範囲(base / head の sha)・コミット一覧と統計・未コミット変更・未追跡ファイル・除外ファイル(lockfile 等は統計のみ)。総変更が小さければ全文 diff も同梱される
- `NO_CHANGES` が返ったら「レビュー対象の変更がない」と報告して終了する
- ユーザーがコミット範囲・ファイル等を指定した場合は base-ref 引数で範囲を合わせる

manifest はメインセッションで **1 回だけ**実行し、出力を次段で各 agent の prompt にそのまま注入する(agent 側に再収集させない)。メインセッションで精読・分析はしない。

## 2. レンズ決定と並列起動

### レンズ registry

- **既定**(無指定時に適用): `design`(設計・可読性)/ `test`(テスト設計・網羅性)
- **オプション**(指定時のみ適用): `security`(セキュリティ / OWASP Top 10)/ `docs`(ドキュメント整合)/ `performance`(計算量・N+1・データサイズ)
- キーワード対応: 「設計」「可読性」→ `design`、「テスト」→ `test`、「セキュリティ」「security」→ `security`、「ドキュメント」「docs」→ `docs`、「パフォーマンス」「性能」→ `performance`

適用ルール:

- **追加指定**(例: 「〇〇観点も見て」): 既定レンズに**加えて**指定レンズを適用する
- **絞り込み指定**(例: 「〇〇だけ」「〇〇のみで」): 指定レンズだけを適用する
- registry に無い観点を指定されたら、その観点名で agent を 1 体起動し一般知識でレビューさせる

### 並列起動

適用レンズ 1 つにつき diff-reviewer agent を 1 体、**1 メッセージ内で同時に起動**する(直列にしない)。各 agent の prompt には必ず以下を含める:

```
レンズ: <lens>
基準ファイル: ~/.claude/skills/diff-review/references/<lens>.md(レビュー開始前に Read すること)
ユーザーの依頼: <元の依頼の要約(範囲・重点の指定があれば含める)>

以下は収集済みの差分 manifest。manifest の再実行はしない。全文 diff が必要な単位のみ
~/.claude/skills/diff-review/scripts/collect-diff.sh の commit / worktree / cumulative で取得する:

<manifest の出力をそのまま貼る>
```

manifest を全 agent に同一内容で渡すことで、レビュー範囲のスナップショットを固定する。

## 3. 統合報告

全 agent の完了後、報告を 1 つに統合し、diff-reviewer の報告形式(must / want+ / want / nit の severity 順)で出力する:

- 冒頭に「対象: <範囲> / レンズ: <適用レンズ>」を明記する
- 同一 `ファイルパス:行番号` に複数レンズの指摘が重なったら 1 件に統合する。severity は最も重いものを採用し、レンズタグを併記する(例: `[design][security]`)
- `[PLAUSIBLE]` マークは統合後も維持する
- 全レンズで指摘ゼロなら「指摘なし」と明言する。褒め言葉・社交辞令は書かない
