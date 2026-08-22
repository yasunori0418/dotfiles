# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 確認・意思決定ルール

- 「各〜の下に」「まとめて」「適宜」などの曖昧な範囲・数量指定が含まれる場合は、候補となる解釈を提示してから着手する。外部システムへの影響が大きい操作では必ず確認する
- 選択・意思決定を伴う確認は原則 **AskUserQuestion**(推奨案を先頭に置く)で提示する。決定間に依存があるとき(前の回答が次の質問に影響するとき)は一問ずつ順に確認し、まとめて投げてよいのは相互に独立で軽微な選択のみ。また呼び出す前に、**質問の要点と各選択肢の内容をメッセージ本文にも必ず書く**(remote-control 経由のスマホ/web で選択UIの前の文脈が表示されない挙動への根本緩和)。なお cchook がセッション単位で AskUserQuestion を deny することがある(トグル: プロンプト本文に `#aq-off` / `#aq-on`)。deny されている場合は選択肢を本文に番号付きで列挙し、番号または自由記述での回答を求める
- 実装計画・リファクタリング計画・タスク分解などの**計画成果物を提示する前(plan モードでは ExitPlanMode の前)に、commit-plan スキルを必ず参照**し、計画にコミット計画セクションを含める

## 環境ルール

- ドキュメント・コードファイルを作成・更新したあとに `open <path>` で自動的にファイルを開かない。ユーザー環境は neovim + tmux 運用で、ターミナル制御で必要なファイルを自分で開き直す。「ファイルを更新しました: `<path>`」と表示するに留める
- 時刻を表示・報告するときは UTC ではなく **JST(日本標準時、UTC+9)** で表記する。Datadog／CloudWatch／GitHub Actions などのログ調査結果を報告する際、タイムスタンプは全て JST に変換する(例：`2026-05-20 12:15:42 JST`)。URL内のUnixタイムスタンプはそのままで良いが、テキストで言及する時刻は必ず JST
- GitHub(`github.com`・GitHub Enterprise)の PR・Issue・Actions(run/job ログ)・commit・diff・比較などの情報取得は、**`WebFetch` を使わず最初から `gh` コマンド経由**で行う(`gh run view --log-failed` / `gh pr view` / `gh api` 等)。URL を渡された時点で gh に解決する
- **コンテキスト肥大を抑制する**。調査・分析の中間結果(ログ抜粋・一覧・比較表など、後続で再参照しないもの)はコンテキストに抱え込まず、scratchpad やプロジェクトの `tmp_claude/` へファイル退避する。コンテキストが肥大した長時間セッション(目安: peak 250k 超)で別トピックの依頼が来たら、新セッションでの継続を提案する
- **2分を超える見込みの重いコマンドは打ち切らせない**。nix ビルド(`nix build`・`nixos-rebuild`・`home-manager switch`)・プロジェクト全体テストなどは、Bash の `run_in_background: true` で実行して完了を待つか、`timeout` を明示的に延長する。既定2分タイムアウト(Exit 143)による作業中断を避ける
- **完了待ちを `sleep` + 再確認のポーリングで行わない**。バックグラウンド処理・別セッションの完了待ちは Bash の `run_in_background: true` の完了通知か Monitor ツールを使う(`sleep N` を挟むポーリングは harness にブロックされ無駄打ちになる)
- **書き出すドキュメントはタスクに必要な長さに合わせる**。レポート・計画・要約・調査結果などのファイル出力は、実質を網羅しつつ、水増しセクション・冗長な再要約・定型文で膨らませない
- **サブエージェント委任は真に独立した大きな作業に限る**(複数ファイル横断調査など)。数回のツール呼び出しで済む作業は委任しない。自分の作業の検証・ダブルチェック目的でサブエージェントを使わない。1 体で足りるなら複数起動しない
- **並列エージェント(agent teams)は使い終わったら明示的に停止する**。`idle_notification`(`idleReason: "available"`)は「作業が終了した」ではなく「空いて待機中」の意味で、放置するとチームメイトが滞留し続ける。成果物を回収してそのエージェントへの追加依頼が無いと判断した時点で `TaskStop` を呼ぶ。反復作業(評価ループ等)で次のイテレーションのエージェントを起動する前には、`TaskList` で前イテレーションの残留を棚卸しして停止済みにしてから起動する。応答終了時の取りこぼしは teammate-leak-guard hook が `decision: block` で差し戻すが、hook はターン終端でしか発火しないため、ターン内での棚卸しはこのルールで担保する
- **エージェントからの返信が来ないときの再送は 1 回まで**。`idle_notification` だけが届いて成果物本体が来ない状態は返信経路の障害とみなし、1 回再送しても届かなければ `TaskStop` で打ち切る。自分で代替検証できるなら実施し、できないならその旨をユーザーへ報告して指示を仰ぐ(応答を待ち続けるポーリングはしない)

## symlink 運用(nput + dotfiles)

この環境の `~/.claude/`・`~/.config/` 配下は nput 管理で、`mkOutOfStoreSymlink`(`home-manager/nputEntries.nix`)により **dotfiles リポジトリ実体(`~/dotfiles/home/...`)へ直結した symlink**。nix store へのコピーではなく**可変**。これを前提に振る舞う。

- **検索は symlink を追従させる**。`fd`・`rg`、および Grep/Glob ツールはデフォルトでディレクトリ symlink を降りない。`~/.claude` / `~/.config` など symlink を含む木を探索するときは `rg -L` / `fd -L`(Bash)を使うか、`readlink` で実体を解決してから探索する。**追従なしの検索が空を返しても「存在しない」と結論しない**(一度 `-L` で再確認する)
- **存在確認はリストを信用しすぎない**。skill が `disable-model-invocation: true` だと起動時の available-skills リストに載らない。skill / command の有無を判断するときは、リストの不在だけで決めず `~/.claude/skills` 等を `-L` 付きで列挙して確かめる
- **編集はリポジトリ実体に直接書き込まれる**。`~/.claude/*`・`~/.config/*` は dotfiles 本体へ直結しているため、`~/.claude/CLAUDE.md` 等を編集するとそのまま `~/dotfiles/home/...`(＝編集すべき source)に書き込まれる。**content の変更は即時反映で再配置不要**。再配置が要るのは `home-manager/nputEntries.nix` の entries にファイルを増減する**構造変更のときだけ**で、そのときも `home-manager switch` ではなく `make nput-apply` で足りる。(万一あるパスが `/nix/store/...` に解決する場合のみ read-only。その時は dotfiles 側を編集する)
- **例外: `~/.claude/settings.json` は copy 配置**。SSOT は `home-manager/claudeSettings.nix`。TUI の書き戻しは通るが `nput apply --recopy` で失われるため、恒久化したい変更は Nix 側へ戻す(詳細は `~/dotfiles/CLAUDE.md`)
- **例外: `~/.claude/skills/*`・`~/.claude/agents/*` は store 直結の read-only**。これらは dotfiles 実体ではなく `yasunori0418/skills` リポジトリ(flake input `yasunori-skills`)から nput が配置する。編集は `~/src/github.com/yasunori0418/skills` で行い、**push → `~/dotfiles` で `nix flake update yasunori-skills` → switch** で反映する(即時反映ではない)。同リポジトリは Claude Code plugin(ローカル marketplace)としても配布しているが、このマシンでは重複回避のため plugin はローカル無効(`enabledPlugins` で false)
