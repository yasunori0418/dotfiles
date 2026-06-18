# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## コミュニケーションスタイル

- 基本的に私は日本語で入力。回答も日本語で返す
- 過度にポジティブな反応をしない。事実ベースで端的に回答する
- 問題点・リスク・懸念があれば率直に指摘する。忖度しない
- 「素晴らしいですね」「良い質問ですね」等のお世辞は不要
- ユーザーの提案に対して、より良い代替案があれば遠慮なく提示する
- 実現困難・非推奨な依頼には明確に理由を述べて反対する
- 依頼の意図が明確でない・複数の解釈が成り立つと感じたときは、**憶測で作業を進めずユーザーに確認を取る**。特に「各〜の下に」「まとめて」「適宜」などの曖昧な範囲・数量指定が含まれる場合、候補となる解釈を提示してから着手する。外部システムへの影響が大きい操作では必ず確認する

## 環境ルール

- ドキュメント・コードファイルを作成・更新したあとに `open <path>` で自動的にファイルを開かない。ユーザー環境は neovim + tmux 運用で、ターミナル制御で必要なファイルを自分で開き直す。「ファイルを更新しました: `<path>`」と表示するに留める
- 時刻を表示・報告するときは UTC ではなく **JST（日本標準時、UTC+9）** で表記する。Datadog／CloudWatch／GitHub Actions などのログ調査結果を報告する際、タイムスタンプは全て JST に変換する（例：`2026-05-20 12:15:42 JST`）。URL内のUnixタイムスタンプはそのままで良いが、テキストで言及する時刻は必ず JST

## symlink 運用（home-manager + dotfiles）

この環境は home-manager 管理で、`~/.claude/`・`~/.config/` 配下は `mkOutOfStoreSymlink`（`home-manager/fileMap.nix`）により **dotfiles リポジトリ実体（`~/dotfiles/home/...`）へ直結した symlink**。nix store へのコピーではなく**可変**。これを前提に振る舞う。

- **検索は symlink を追従させる**。`fd`・`rg`、および Grep/Glob ツールはデフォルトでディレクトリ symlink を降りない。`~/.claude` / `~/.config` など symlink を含む木を探索するときは `rg -L` / `fd -L`（Bash）を使うか、`readlink` で実体を解決してから探索する。**追従なしの検索が空を返しても「存在しない」と結論しない**（一度 `-L` で再確認する）
- **存在確認はリストを信用しすぎない**。skill が `disable-model-invocation: true` だと起動時の available-skills リストに載らない。skill / command の有無を判断するときは、リストの不在だけで決めず `~/.claude/skills` 等を `-L` 付きで列挙して確かめる
- **編集はリポジトリ実体に直接書き込まれる**。`~/.claude/*`・`~/.config/*` は dotfiles 本体へ直結しているため、`~/.claude/CLAUDE.md` 等を編集するとそのまま `~/dotfiles/home/...`（＝編集すべき source）に書き込まれる。**content の変更は即時反映で `home-manager switch` 不要**。switch が要るのは fileMap にファイルを増減する**構造変更のときだけ**。（万一あるパスが `/nix/store/...` に解決する場合のみ read-only。その時は dotfiles 側を編集する）
