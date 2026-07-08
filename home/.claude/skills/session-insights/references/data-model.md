# Claude Code ユーザーデータのデータモデル

`collect_sessions.py` が読むデータの構造と、その根拠・注意点。
スクリプトの出力だけで分析が完結しない場合（新しいレコード型が現れた等）に参照する。

## 設定ディレクトリの解決

公式: https://code.claude.com/docs/en/claude-directory.md

- 既定は `~/.claude/`（Windows は `%USERPROFILE%\.claude`）
- **`CLAUDE_CONFIG_DIR` 環境変数が設定されていると、全ての `~/.claude` パスがそのディレクトリ配下に置き換わる**（公式ドキュメントに明記。ただし env-vars リファレンスには詳細記載がない）
- XDG_CONFIG_HOME への準拠は無い
- スクリプトの解決順: `--config-dir`（テスト用） → `$CLAUDE_CONFIG_DIR` → `~/.claude`

## ディレクトリ配置（公式ドキュメント準拠）

| パス | 内容 | 保持 |
|---|---|---|
| `projects/<project>/<session-id>.jsonl` | セッション transcript（JSONL） | 既定30日で自動削除（`cleanupPeriodDays` で変更可） |
| `projects/<project>/<session-id>/subagents/agent-*.jsonl` | サブエージェント会話 | 同上 |
| `projects/<project>/<session-id>/tool-results/` | 大きなツール出力 | 同上 |
| `projects/<project>/memory/` | オートメモリ（`MEMORY.md` + トピック別 `.md`） | 手動削除のみ |
| `history.jsonl` | 全プロンプト履歴（`{display, timestamp(ms), project}`） | 永続 |
| `settings.json` / `settings.local.json` | ユーザー設定 | 永続 |
| `CLAUDE.md` | グローバル個人指示 | 永続 |
| `skills/` `commands/` `agents/` `rules/` `workflows/` `output-styles/` | グローバル定義 | 永続 |
| `plugins/` | プラグイン（`installed_plugins.json` 等） | 永続 |
| `stats-cache.json` | トークン・コスト集計（`/usage` 用） | 永続 |
| `plans/` `tasks/` `file-history/` `shell-snapshots/` | 補助データ | 30日 |

`<project>` はセッション開始時の cwd を `-` 区切りにエンコードしたもの
（例: `/Users/x/dotfiles` → `-Users-x-dotfiles`）。正確な cwd は transcript 内の
`cwd` フィールドから取るのが確実（スクリプトはそうしている）。

設定の優先順位（高→低）: managed settings → CLIフラグ →
`.claude/settings.local.json` → `.claude/settings.json` → `~/.claude/settings.json`。
配列（`permissions.allow` 等）は全スコープ合算、スカラー（`model` 等）は最詳細スコープ優先。

ホームディレクトリ直下の `~/.claude.json` は Claude Code が管理する状態ファイル
（オンボーディング状態・プロジェクト別の `allowedTools`・`lastCost` 等）。

## セッション JSONL のレコード型

**公式には内部フォーマット扱いで、バージョン間で変わることが明記されている**
（https://code.claude.com/docs/en/sessions.md）。以下は v2.1.x 時点の実測。
スクリプトが寛容パース（未知型スキップ）なのはこのため。新レコード型が
集計に必要になったら `reduce_session` に足す。

各行は JSON オブジェクトで `type` を持つ:

| type | 内容 | スクリプトでの扱い |
|---|---|---|
| `user` | ユーザーメッセージ or tool_result 返却 | prompt 抽出・エラー抽出・command 抽出 |
| `assistant` | アシスタント応答。`message.model` / `message.usage` / content ブロック（`text`, `thinking`, `tool_use`） | ツール・スキル・モデル・トークン集計 |
| `system` | subtype: `turn_duration`（`durationMs`）, `compact_boundary`（`compactMetadata.preTokens/trigger`）, `local_command`, `stop_hook_summary`, `away_summary` | ターン時間・compact・command 集計 |
| `attachment` | hook 実行結果等 | 無視 |
| `permission-mode` | `permissionMode`（plan/acceptEdits等） | セッションの mode 集合 |
| `ai-title` | `aiTitle` = セッションの自動タイトル | タイトル |
| `pr-link` | `prUrl` 等、セッション中に作った PR | 成果物リンク |
| `agent-setting` / `agent-name` | このセッションが Agent/Task から起動されたときの subagent type / 名前 | `spawned_as_agent` 判定（既定で集計から除外） |
| `file-history-snapshot`, `last-prompt`, `mode`, `queue-operation` | UI/内部状態 | 無視 |

共通フィールド（付いている行のみ）: `uuid`, `parentUuid`, `timestamp`（ISO8601 UTC）,
`sessionId`, `cwd`, `gitBranch`, `version`, `isSidechain`, `isMeta`, `isCompactSummary`。

### 「実プロンプト」の判定（prompt_text）

`type=user` のうち以下を除外した残りが人間の入力:

- `isMeta` / `isSidechain` / `isCompactSummary` が真
- content が `tool_result` ブロックのみ
- `Caveat:` で始まる（注入文）
- `<command-name>` を含む（スラッシュコマンドのエコー。command として別集計）
- `<local-command-stdout>` / `<task-notification>` / `<system-reminder>` 始まり

### トークン集計の読み方

- `usage.input` は素の input tokens。**実際のコンテキスト量は
  `input + cache_read + cache_creation`**（= `peak_context` の算出式）
- セッション合計の `cache_read` はメッセージ数に比例して膨らむ
  （毎ターン読み直すため）。「合計何トークン消費したか」ではなく
  「キャッシュ依存度」の指標として読む
- `compact_boundary` の `preTokens` は compact 直前のコンテキスト量。
  `trigger: auto|manual` で自動/手動を区別できる
- **トークン総量・コスト（USD）は ccusage へ移譲**（`usage --engine auto`）。
  ccusage は messageId+requestId による重複レコード排除とモデル別の価格計算を
  行うため、絶対量・金額はそちらが正確。builtin の `usage_total` は生レコードの
  単純合算（リトライ等で重複しうる）で、比率・内訳の把握用。ccusage も
  `CLAUDE_CONFIG_DIR` を尊重する（スクリプトが子プロセスへ引き渡す）

## 公式が推奨する代替アクセス手段

transcript の直接パースが壊れた場合の代替:

- `claude -p --output-format json` / `--resume <session-id>`（構造化出力）
- `/export`（可読テキスト）
- Agent SDK
