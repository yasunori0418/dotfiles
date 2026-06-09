# プラットフォーム別リファレンス

PR/MR 作成の CLI コマンド・テンプレート配置・フォールバックをプラットフォームごとにまとめる。プラットフォーム・ベースブランチ・push 状態の判定は `scripts/pr-context.sh`（SKILL.md §1）が出力するので、ここでは扱わない。スクリプトの `PLATFORM` セクションが指す CLI の該当節を読む。

## 共通の前提

- **自動 push しない**。どのプラットフォームでも、リモート未 push のブランチに対して push を代行しない。
- **作成は draft 既定**、**作成前にユーザー承認**。
- 本文は heredoc やファイル渡しで安全に渡す（改行・特殊文字の崩れを避ける）。一時ファイルを使う場合は `tmp_claude/` 配下（tmp-output スキル準拠）に置き、作成後は不要なら削除。

## GitHub (`gh`)

CLI が `installed: no` のときは認証も含め `gh auth status` で確認し、不可なら手動作成へ。

### テンプレート配置（探索順）
1. `.github/pull_request_template.md`
2. `.github/PULL_REQUEST_TEMPLATE.md`
3. `pull_request_template.md`（ルート）
4. `docs/pull_request_template.md`
5. `.github/PULL_REQUEST_TEMPLATE/*.md`（複数テンプレ。`?template=` 相当。候補提示）

### 作成
```bash
gh pr create \
  --base "<base>" \
  --head "<current-branch>" \
  --title "<title>" \
  --draft \
  --body-file <(cat <<'EOF'
<body>
EOF
)
```
- 非 draft 指定時は `--draft` を外す。
- `--body-file -` で標準入力からも渡せる。`--body "..."` は短文のみ。
- ブラウザで開くだけにしたいなら `--web`（テンプレ自動適用されるが、こちらで埋めた本文は渡らない点に注意）。

### 既存 PR 確認
```bash
gh pr list --head "<current-branch>"   # 既に PR があれば二重作成を避ける
```

## GitLab (`glab`)

### テンプレート配置
- `.gitlab/merge_request_templates/*.md`（`Default.md` があれば既定）

### 作成
```bash
glab mr create \
  --target-branch "<base>" \
  --source-branch "<current-branch>" \
  --title "<title>" \
  --draft \
  --description "<body>"
```
- GitLab の draft はタイトル先頭 `Draft:` でも表現される。`--draft` フラグが効かない版では `Draft: <title>` を使う。
- 長文 description はファイル経由が安全: 一時ファイルに書き `--description "$(cat <file>)"`。

## その他・フォールバック

GitHub/GitLab 以外（Gitea, Bitbucket, codeberg 等）、または対応 CLI が見つからない・未認証の場合:

1. push 状態を確認（未 push ならユーザーに依頼して停止）。
2. 生成したタイトルと本文をチャットに提示。
3. 該当プラットフォームの Web UI で作成するよう案内し、本文をそのまま貼り付けられる形で渡す。
4. 該当 CLI（例: `tea`）が使えそうなら、ユーザーに利用可否を確認してからコマンドを提案する。
