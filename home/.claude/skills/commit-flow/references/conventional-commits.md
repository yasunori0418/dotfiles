# Conventional Commits 詳細仕様

`SKILL.md` §5 から参照。フォーマットの詳細・type 一覧・例・アンチパターンを記載。

仕様の正典: [Conventional Commits 1.0.0](https://www.conventionalcommits.org/)

## 基本フォーマット

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## type 一覧

| type | 用途 |
|---|---|
| `feat` | 新機能の追加 |
| `fix` | バグ修正 |
| `docs` | ドキュメントのみの変更 |
| `style` | コードの意味に影響しない変更（フォーマット・空白・セミコロン等） |
| `refactor` | バグ修正でも機能追加でもないコード変更 |
| `perf` | パフォーマンス改善 |
| `test` | テストの追加・修正 |
| `build` | ビルドシステム・外部依存の変更（npm/gradle/cargo 等） |
| `ci` | CI 設定・スクリプトの変更（GitHub Actions 等） |
| `chore` | その他の雑務（リリース作業・設定変更等） |
| `revert` | 過去コミットの取り消し |

迷ったら「読み手が履歴を遡る時にどのカテゴリで探すか」で判断する。

## scope（任意）

影響範囲を `()` で括る。プロジェクト固有のモジュール名・パッケージ名・機能名を使う。

## description（必須）

- 現在形・命令形（「追加した」ではなく「追加する」「Add」「Fix」）
- 英語の場合は先頭小文字、日本語は通常文体
- 末尾にピリオド／句点を付けない
- 50 文字以内が目安

## body（任意）

description だけで伝わらない「なぜ」「何を」「どう」を補足。description との間に空行 1 つ。1 行 72 文字以内。

## footer（任意）

- `BREAKING CHANGE: <description>` で破壊的変更を明示
- `Refs: #123`, `Closes: #456` で関連 Issue/PR を参照（`Closes #<n>` でマージ時に GitHub が issue を自動 close）

## 破壊的変更

```
feat!: API v2 にメジャーアップグレード

BREAKING CHANGE: /api/v1/* は削除済み
```

`!` 単独でも可（footer の `BREAKING CHANGE:` と併用すると明確）。

## 例

```
feat(plan-sheet): 部署別フィルタを追加
fix(report): 月次集計で12月分が抜ける問題を修正
refactor(domain): TableauAggregator を value object に変換
test(infra): TableauPublisherTest に異常系を追加
chore: flake.lock を更新
docs(claude): スキル運用ルールを CLAUDE.md から分離
build(gradle): kotlin を 2.0.21 にアップグレード
revert: feat(auth): JWT 認証を追加
```

## アンチパターン → 修正例

| 悪い例 | 何が問題か | 修正例 |
|---|---|---|
| `update: 色々修正` | type 規約外＋ description 曖昧＋粒度不明 | 内容ごとに分割し `fix(parser): NPE を修正` / `refactor(domain): 命名整理` |
| `fix: バグ修正しました。` | 末尾句点、丁寧語、内容ゼロ | `fix(report): 月次集計で12月分が欠落する問題を修正` |
| `feat(auth): added JWT auth` | 過去形（現在形ルール違反） | `feat(auth): add JWT auth` |
| `feat: ログイン追加 と バリデーション修正` | 1 コミットに複数論理変更が混在（SKILL §3 違反） | コミットを分割し `feat(auth): ログイン機能を追加` ／ `fix(form): バリデーションエラーを修正` |
