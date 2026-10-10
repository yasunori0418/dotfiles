# CLAUDE.md

## 確認・意思決定ルール

- 「各〜の下に」「まとめて」「適宜」などの曖昧な範囲・数量指定が含まれる場合は、候補となる解釈を提示してから着手する。外部システムへの影響が大きい操作では必ず確認する
- 選択・意思決定を伴う確認は原則 AskUserQuestion(推奨案を先頭に置く)で提示する。決定間に依存があるとき(前の回答が次の質問に影響するとき)は一問ずつ順に確認し、まとめて投げてよいのは相互に独立で軽微な選択のみ。また呼び出す前に、質問の要点と各選択肢の内容をメッセージ本文にも必ず書く(remote-control 経由のスマホ/web で選択UIの前の文脈が表示されない挙動への根本緩和)。なお askuserquestion-guard hook がセッション単位で AskUserQuestion を deny することがある(トグル: プロンプト本文に `#aq-off` / `#aq-on`)。deny されている場合は選択肢を本文に番号付きで列挙し、番号または自由記述での回答を求める
- 実装計画・リファクタリング計画・タスク分解などの計画成果物を提示する前(plan モードでは ExitPlanMode の前)に、commit-plan スキルを必ず参照し、計画にコミット計画セクションを含める

## 環境ルール

- 時刻を表示・報告するときは UTC ではなく JST(日本標準時、UTC+9) で表記する。Datadog／CloudWatch／GitHub Actions などのログ調査結果を報告する際、タイムスタンプは全て JST に変換する(例：`2026-05-20 12:15:42 JST`)。URL内のUnixタイムスタンプはそのままで良いが、テキストで言及する時刻は必ず JST
- GitHub(`github.com`・GitHub Enterprise)の PR・Issue・Actions(run/job ログ)・commit・diff・比較などの情報取得は、`WebFetch` を使わず最初から `gh` コマンド経由で行う(`gh run view --log-failed` / `gh pr view` / `gh api` 等)。URL を渡された時点で gh に解決する
- コンテキスト肥大を抑制する。調査・分析の中間結果(ログ抜粋・一覧・比較表など、後続で再参照しないもの)はコンテキストに抱え込まず、scratchpad へファイル退避する(ユーザー向けの成果物は tmp-output スキルに従う)。コンテキストが肥大した長時間セッション(目安: peak 250k 超)で別トピックの依頼が来たら、新セッションでの継続を提案する
- Bash は `setopt noclobber` の zsh で実行される。既存ファイルへ `>` で書くと上書きされずに `zsh: file exists:` で失敗する。上書きしたいときは `>|` を使う(特にループ内のリダイレクトは 2 周目以降が全て失敗し、exit code は 0 のまま出力が 1 周目で固定される)
- 既定の Bash タイムアウトは 50 分(`BASH_DEFAULT_TIMEOUT_MS`)。それを超えうる nix ビルド・全体テストは `run_in_background: true` で実行する

## symlink 運用(layat + dotfiles)

この環境の `~/.claude/`・`~/.config/` 配下は layat 管理で、`mkOutOfStoreSymlink`(`home-manager/layatEntries.nix`)により dotfiles リポジトリ実体(`~/dotfiles/home/...`)へ直結した symlink。nix store へのコピーではなく可変。これを前提に振る舞う。

- 検索は symlink を追従させる。`fd`・`rg`、および Grep/Glob ツールはデフォルトでディレクトリ symlink を降りない。`~/.claude` / `~/.config` など symlink を含む木を探索するときは `rg -L` / `fd -L`(Bash)を使うか、`readlink` で実体を解決してから探索する。追従なしの検索が空を返しても「存在しない」と結論しない(一度 `-L` で再確認する)
- 存在確認はリストを信用しすぎない。skill が `disable-model-invocation: true` だと起動時の available-skills リストに載らない。skill / command の有無を判断するときは、リストの不在だけで決めず `~/.claude/skills` 等を `-L` 付きで列挙して確かめる
- 編集はリポジトリ実体に直接書き込まれる。`~/.claude/*`・`~/.config/*` は dotfiles 本体へ直結しているため、`~/.claude/CLAUDE.md` 等を編集するとそのまま `~/dotfiles/home/...`(＝編集すべき source)に書き込まれる。content の変更は即時反映で再配置不要。再配置が要るのは `home-manager/layatEntries.nix` の entries にファイルを増減する構造変更のときだけで、そのときも `home-manager switch` ではなく `make layat-apply` で足りる。(万一あるパスが `/nix/store/...` に解決する場合のみ read-only。その時は dotfiles 側を編集する)
- 例外: `~/.claude/settings.json` は copy 配置。SSOT は `home-manager/claudeSettings.nix`。TUI の書き戻しは通るが `layat apply --recopy` で失われるため、恒久化したい変更は Nix 側へ戻す(詳細は `~/dotfiles/CLAUDE.md`)
- 例外: `~/.claude/skills/*`・`~/.claude/agents/*` は store 直結の read-only。これらは dotfiles 実体ではなく `yasunori0418/skills` リポジトリ(flake input `yasunori-skills`)から layat が配置する。編集は `~/src/github.com/yasunori0418/skills` で行い、push → `~/dotfiles` で `nix flake update yasunori-skills` → `make layat-apply` で反映する(switch 不要。即時反映ではない)。同リポジトリは Claude Code plugin(ローカル marketplace)としても配布しているが、このマシンでは重複回避のため plugin はローカル無効(`enabledPlugins` で false)
