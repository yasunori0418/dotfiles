---
name: pr-create
description: "リポジトリの PR/MR テンプレートに沿って Pull Request / Merge Request を作成する。テンプレートを自動検出して埋め、無ければ汎用観点で本文を構成。テンプレ／リポジトリの言語に合わせて記述。GitHub(gh) 基本、GitLab(glab) 等にも対応。"
disable-model-invocation: true
argument-hint: "[ベースブランチ名や追加指示（任意）]"
---

# PR 作成

リポジトリ固有の PR テンプレートに沿った PR を写経なしで作成する。テンプレートが無くても汎用観点で過不足ない PR を作る。`disable-model-invocation: true` により `/pr-create` の明示実行時のみ動作する。

## 制約（厳守）

- **自動 push 禁止**。未 push でもスキルが `git push` してはならない。push が必要なら**ユーザーに依頼して停止**。
- 作成は **draft が既定**。「通常 PR で」の指示時のみ非 draft。
- **作成前に必ずタイトルと本文を提示しユーザー承認を得てから** 作成コマンドを実行する。

## ワークフロー

### 1. コンテキスト収集（スクリプト）

プラットフォーム判定・ベース特定・差分・push 状態は決定論的に行えるため `scripts/pr-context.sh` を実行する。手で git コマンドを並べ直さない。

```bash
bash <skill-dir>/scripts/pr-context.sh [base-branch]
```

`=== SECTION ===` 区切りの出力を読む:

- **PLATFORM** = remote URL から判定したプラットフォームと使用 CLI・導入有無。`github`→`gh`、`gitlab`→`glab`、`unknown`/`installed: no` → 本文を提示して手動作成を案内。コマンド詳細は `references/platforms.md`。
- **BASE BRANCH** = リモート既定ブランチではなく、**作業ブランチの分岐元**をローカル探索した結果。`(特定できませんでした)` や誤検出が疑わしいときは引数 `base-branch` を渡して再実行、またはユーザーに確認。
- **COMMITS / COMMIT MESSAGES** = 本文の主素材。
- **DIFF STAT / CHANGED FILES** = 変更範囲。完全差分が要れば末尾の `git diff <base>...HEAD` を別途実行。
- **UPSTREAM / PUSH STATUS** に WARNING（未 push／未 push コミットあり）が出たら、制約どおり**作成に進まずユーザーに push を依頼して停止**。

### 2. テンプレート探索

`find .github .gitlab docs -iname '*template*' 2>/dev/null` 等で探す（配置一覧は `references/platforms.md`）。最初に見つかったものを使い、複数テンプレ（ディレクトリ形式）は候補提示して選んでもらう。

### 3. 言語判定

本文の言語は次の優先順で決める。①テンプレートがある → **テンプレートの見出し・コメントの言語に合わせる**。②無い → 直近コミットや README の言語。③不明 → ユーザーに確認。

### 4. 本文生成

**テンプレートあり**: 構造（見出し・チェックリスト・HTML コメント）を保ったまま差分・コミットから各セクションを埋める。

- `<!-- ... -->` は指示として読み、埋めた後の扱いはテンプレ慣習・既存 PR に倣う。
- チェックリスト `- [ ]` は差分から確実に満たすものだけ `- [x]`。不明は未チェックで残し、全部チェックしない。
- 推測で事実を捏造しない。差分から読めない背景は埋めず、ユーザーに補完を促す。

**テンプレートなし**: 下記の汎用構成（言語は §3 準拠、不要セクションは省く）。

```markdown
## 概要
<!-- この PR で何をするか 1〜2 行 -->
## 変更内容
<!-- 主な変更点を箇条書き -->
## 変更の背景・理由
<!-- なぜ必要か。関連課題・経緯 -->
## 動作確認
<!-- どう確認したか。テスト・検証手順 -->
## 影響範囲・注意点
<!-- 影響箇所・レビュー注意点・未対応事項 -->
## 関連 Issue / リンク
<!-- Closes #xxx など -->
```

### 5. タイトル

Conventional Commits 形式（`<type>(<scope>): <subject>`、commit-flow スキル準拠）を基本。単一コミットはそのメッセージを流用、複数は全体を要約。既存 PR にタイトル規約があればそれを優先。

### 6. 確認 → 作成

タイトルと本文をチャットに提示 → ユーザー承認 → draft 作成（コマンドは `references/platforms.md`）→ PR の URL を報告。

## 参照

- `scripts/pr-context.sh` — プラットフォーム判定・ベース特定〜差分・push 状態を出す read-only スクリプト（§1）。
- `references/platforms.md` — プラットフォーム別 CLI コマンド・テンプレ配置・手動作成フォールバック。
