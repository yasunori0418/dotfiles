# CLAUDE.md

## 確認・意思決定ルール

- 「各〜の下に」「まとめて」「適宜」などの曖昧な範囲・数量指定が含まれる場合は、候補となる解釈を提示してから着手する
- 選択・意思決定を伴う確認は原則 AskUserQuestion で提示する。決定間に依存があるとき(前の回答が次の質問に影響するとき)は一問ずつ順に確認し、まとめて投げてよいのは相互に独立で軽微な選択のみ。また呼び出す前に、質問の要点と各選択肢の内容をメッセージ本文にも必ず書く(remote-control 経由のスマホ/web で選択UIの前の文脈が表示されない挙動への根本緩和)
- 実装計画・リファクタリング計画・タスク分解などの計画成果物を提示する前(plan モードでは ExitPlanMode の前)に、commit-plan スキルを必ず参照し、計画にコミット計画セクションを含める

## 環境ルール

- 時刻を表示・報告するときは UTC ではなく JST(UTC+9) に変換して表記する(例：`2026-05-20 12:15:42 JST`)。URL 内の Unix タイムスタンプはそのままで良い
- GitHub(`github.com`・GitHub Enterprise)の情報取得は、`WebFetch` を使わず最初から `gh` コマンド経由で行う。URL を渡された時点で gh に解決する
- 調査・分析の中間結果(ログ抜粋・一覧・比較表など、後続で再参照しないもの)はコンテキストに抱え込まず、scratchpad へファイル退避する。コンテキストが肥大した長時間セッション(目安: peak 500k 超)で別トピックの依頼が来たら、新セッションでの継続を提案する
- Bash は `setopt noclobber` の zsh で実行される。既存ファイルへの上書きは `>` ではなく `>|` を使う。noclobber-guard hook は相対パス・変数経由の書き先と、ループ内の 2 周目以降(exit code 0 のまま出力が 1 周目で固定される)を検知できない
- 一時領域(scratchpad・`/tmp`・gitignore 済みの `tmp-agents/` 等)の `rm` は、他の処理と混ぜずに単独の Bash 呼び出しにする。対象は絶対パスか同じコマンド内の単純な代入で書き、引用符・glob・パイプ・バックグラウンド実行を使わない(確認用の `ls` / `echo` / `git status` と `2>/dev/null`・`|| echo` は並べてよい)。permission-gate はこの形だけを自動承認し、混ぜると毎回確認ダイアログが出る
- 既定の Bash タイムアウト(50 分)を超えうる nix ビルド・全体テストは `run_in_background: true` で実行する

## symlink 運用(layat + dotfiles)

この環境の `~/.claude/`・`~/.config/` 配下は layat 管理で、dotfiles リポジトリ実体(`~/dotfiles/home/...`)へ直結した symlink。nix store へのコピーではなく可変。これを前提に振る舞う。

- 検索は symlink を追従させる。`fd`・`rg`、および Grep/Glob ツールはデフォルトでディレクトリ symlink を降りない。`~/.claude` / `~/.config` など symlink を含む木を探索するときは `rg -L` / `fd -L`(Bash)を使うか、`readlink` で実体を解決してから探索する。追従なしの検索が空を返しても「存在しない」と結論しない(一度 `-L` で再確認する)
- 存在確認はリストを信用しすぎない。skill が `disable-model-invocation: true` だと起動時の available-skills リストに載らない。skill / command の有無を判断するときは、リストの不在だけで決めず `~/.claude/skills` 等を `-L` 付きで列挙して確かめる
- 編集は実体パス(`~/dotfiles/home/...`)に対して行う。symlink パス(`~/.claude/CLAUDE.md` 等)への Edit / Write は拒否される。content の変更は即時反映で再配置不要(配置するファイルを増減する構造変更の手順は `~/dotfiles/AGENTS.md`)
- 例外: `~/.claude/settings.json` は copy 配置。SSOT は `home-manager/claudeSettings.nix`。TUI の書き戻しは通るが `layat apply --recopy` で失われるため、恒久化したい変更は Nix 側へ戻す(詳細は `~/dotfiles/AGENTS.md`)
- 例外: `~/.claude/skills/*`・`~/.claude/agents/*`・`~/.claude/hooks/*` の大半は store 直結の read-only。これらは dotfiles 実体ではなく `yasunori0418/skills` リポジトリ(flake input `yasunori-skills`)から layat が配置する。編集は `~/src/github.com/yasunori0418/skills` で行い、push → `~/dotfiles` で `nix flake update yasunori-skills` → `make layat-apply` で反映する(switch 不要。即時反映ではない)
