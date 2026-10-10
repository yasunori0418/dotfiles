/*
  ~/.claude/settings.json の `hooks` を組み立てる。

  hook 本体は yasunori-skills（flake input）が Claude Code plugin 形式で配布しており、
  各 plugin の hooks/hooks.json に settings.json と同じ構造（event → [{matcher, hooks}]）の
  定義が同梱されている。ここではそれを Nix 評価時に読み込み、plugin 用の
  `${CLAUDE_PLUGIN_ROOT}/hooks/<name>/main.sh` を layat が配置する
  `$HOME/.claude/hooks/<name>/main.sh`（layatFileMap.nix の yasunoriHookSubpaths）へ
  読み替えてマージする。定義を手で写さないので、skills 側の matcher 変更に
  flake update だけで追随できる。

  以前は cchook（YAML → hook JSON の変換レイヤ）に全 event を集約していたが、
  cchook は PermissionRequest で「無出力 = ユーザーに委ねる」を表現できず
  （空セクションは全 allow、command の無出力は全 deny に倒れる）、
  PreToolUse でも非ゼロ終了を deny に変換するなど、event ごとに空出力の意味が
  異なる変換を抱えていた。hook script 自体は Claude Code の出力契約
  （該当しなければ無出力・exit 0）で書かれているので、settings.json へ直接登録する。

  plugin の読み替え先は store path ではなく layat の symlink にする。settings.json は
  copy（place-once）配置のため、store hash を直書きすると flake update のたびに
  recopy しないと古い store path を指し続けるが、symlink 先は layat apply が追随する。
*/
{
  lib,
  # inputs.yasunori-skills
  skills,
  # layatFileMap.nix の yasunoriHookSubpaths（<name> = "<plugin>/hooks/<name>"）。
  # plugin 一覧をここから導出し、hooks.json が参照する hook が全て配置されることを検査する。
  hookSubpaths,
}:
let
  hookRoot = "$HOME/.claude/hooks/";

  pluginDirs = lib.pipe hookSubpaths [
    lib.attrValues
    (map (p: dirOf (dirOf p)))
    lib.unique
  ];

  readPluginHooks =
    plugin: (builtins.fromJSON (builtins.readFile "${skills}/${plugin}/hooks/hooks.json")).hooks;

  pluginRoot = "\${CLAUDE_PLUGIN_ROOT}";

  # hooks.json の形は event → [ { matcher, hooks = [ { type, command } ] } ] で固定。
  # 読み替えるのは hooks[].command だけ（matcher 等は触らない）。
  rewriteRoot = lib.mapAttrs (
    _event:
    map (
      m:
      m
      // {
        hooks = map (
          h:
          if h ? command then
            h // { command = lib.replaceString "${pluginRoot}/hooks/" hookRoot h.command; }
          else
            h
        ) m.hooks;
      }
    )
  );

  # 複数 plugin / 手書き分を event ごとにリスト連結する（recursiveUpdate はリストを
  # 置き換えてしまうので使わない）。
  mergeHooks = lib.zipAttrsWith (_: lib.concatLists);

  fromSkills = mergeHooks (map (p: rewriteRoot (readPluginHooks p)) pluginDirs);

  skillCommands = lib.pipe fromSkills [
    lib.attrValues
    lib.concatLists
    (lib.concatMap (m: m.hooks))
    (lib.concatMap (h: lib.optional (h ? command) h.command))
  ];
  # 読み替えられなかった command（hooks/ 直下以外を指すなど、置換パターン外の形）
  unrewritten = lib.filter (lib.hasInfix pluginRoot) skillCommands;
  # hooks.json が参照する hook 名（$HOME/.claude/hooks/<name>/...）を集める。
  referencedHookNames = lib.pipe skillCommands [
    (lib.filter (lib.hasPrefix hookRoot))
    (map (c: lib.head (lib.splitString "/" (lib.removePrefix hookRoot c))))
    lib.unique
  ];
  missingHooks = lib.subtractLists (lib.attrNames hookSubpaths) referencedHookNames;

  # yasunori-skills の外にある hook。
  extraHooks = {
    PreToolUse = [
      {
        matcher = "Bash";
        hooks = [
          {
            type = "command";
            # tirith による Bash コマンド走査（URL の homograph 検査・pipe-to-shell 検知など）。
            # tirith リポジトリ配布の tirith-check.py を layat で symlink 配置しており、
            # 依存は標準ライブラリのみ。uv 経由で python を 3.13 に固定する。
            #
            # env -u で uv 系の環境変数を落としてから起動する。これは hooks のうち唯一
            # 「外部インタプリタを直接起動する」形で、呼び出し元セッションの環境変数を
            # そのまま受けるため。cryoflow の devShell が direnv 経由で注入する
            # UV_PYTHON_PREFERENCE=only-system + UV_PYTHON_DOWNLOADS=never により
            # uv 管理の 3.13 が候補から外れて uv が exit 2 で落ち、Bash がコマンド内容に
            # 依らず全面 deny になる事故が起きた（2026-09-19 17:32 JST / session 3796d142）。
            #
            # fail-open: tirith は走査であって可用性の前提ではないので、落ちても Bash を
            # 止めない。PreToolUse hook の exit 2 は Claude Code 側でも deny になるため、
            # このラッパーは settings.json 直登録でも必要。TIRITH_FAIL_OPEN=1 は
            # tirith-check.py 内部エラー用の公式スイッチで、uv 自体の起動失敗はそこへ
            # 到達しないため `||` 側で拾う。黙って無効化されるのを避けるため stderr に警告を残す。
            command = ''env -u UV_PYTHON -u UV_PYTHON_PREFERENCE -u UV_PYTHON_DOWNLOADS -u UV_NO_SYNC TIRITH_FAIL_OPEN=1 uv run --python 3.13 -- $HOME/.claude/hooks/tirith/tirith-check.py || { echo "tirith hook skipped (uv/python unavailable); Bash scanning disabled for this call" >&2; exit 0; }'';
          }
        ];
      }
    ];
    SessionStart = [
      {
        hooks = [
          {
            type = "command";
            # herdr（コーディングエージェント用ターミナルマルチプレクサ）へ、この pane で
            # 動いている Claude セッションの session_id / transcript_path を報告する。
            # herdr 側の integration インストーラは settings.json へ直接 hook を書き込むが、
            # settings.json は claudeSettings.nix が SSOT で recopy すると消えるためここに置く。
            # HERDR_ENV / HERDR_SOCKET_PATH / HERDR_PANE_ID が無ければ自己抑制して終了する。
            # 実体は layat 配置（layatFileMap.nix の herdrEntries、flake input `herdr`）で、
            # herdr リポジトリ側のアセットに実行ビットが無い（store 上で -r--r--r--）ため
            # herdr 純正の settings.json 定義と同様にインタプリタ（sh）経由で起動する。
            command = "sh $HOME/.claude/hooks/herdr/herdr-agent-state.sh session";
          }
        ];
      }
    ];
  };
in
assert lib.assertMsg (unrewritten == [ ]) ''
  claudeHooks.nix: ${pluginRoot} を読み替えられない command がある: ${toString unrewritten}
'';
assert lib.assertMsg (
  referencedHookNames != [ ]
) "claudeHooks.nix: hooks.json から hook が 1 つも読めていない";
assert lib.assertMsg (missingHooks == [ ]) ''
  claudeHooks.nix: hooks.json が参照する hook が layatFileMap.nix の yasunoriHookSubpaths に無い: ${toString missingHooks}
'';
mergeHooks [
  fromSkills
  extraHooks
]
