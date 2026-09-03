/*
  ~/.claude/settings.json を Nix attrset から生成する。

  従来は home/.claude/settings.{linux,macos}.json の 2 つの手書き JSON を
  out-of-store symlink で配置していたが、OS 間で共通部（hooks の全 event・
  permissions・env の大半）が重複し、差分が意図せず揺れていた。
  共通部を common に一元化し、OS 固有分だけを perOS で上書きする。

  配置は nput の method = "copy"（nputFileMap.nix 側）。symlink（store 直結）だと
  Claude Code の TUI / `/config` が settings.json へ書き戻す項目
  （effortLevel・outputStyle・enabledPlugins 等）が read-only エラーになるため。
  nput の copy は store の read-only モードに owner-write を加えて配置するので
  書き戻せる。

  ただし copy は place-once（→ nput ADR-0002, ADR-0020）で、一度実体化した
  target には以降 `nput apply` は触れない。ここを編集して反映するには
  `nput apply --recopy` か `nput reset` 後の再適用が要る。
  逆に TUI 側の書き戻しは --recopy で失われるため、恒久化したい変更は
  この Nix 側へ手で戻す運用になる（SSOT は Nix 側）。
*/
{ pkgs, isDarwin }:
let
  inherit (pkgs) lib;

  jsonFormat = pkgs.formats.json { };

  # cchook が受け付ける event をすべて同じ形で受けるため、event 名から生成する。
  # 一覧は `cchook -event <invalid>` のエラーメッセージが権威（= cchook 側の
  # サポート範囲）。cchook を更新したらここも追随させる。config.yaml に
  # 該当セクションが無い event は何もせず終了するので、空セクションでも
  # 登録しておいて問題ない。
  cchookEvents = [
    "Notification"
    "PermissionRequest"
    "PostToolUse"
    "PreCompact"
    "PreToolUse"
    "SessionEnd"
    "SessionStart"
    "Stop"
    "SubagentStart"
    "SubagentStop"
    "UserPromptSubmit"
  ];
  hooks = lib.genAttrs cchookEvents (event: [
    {
      hooks = [
        {
          type = "command";
          command = "cchook -event ${event}";
        }
      ];
    }
  ]);

  common = {
    "$schema" = "https://json.schemastore.org/claude-code-settings.json";
    cleanupPeriodDays = 876000;

    env = {
      # 重いコマンド（nix build / nixos-rebuild / home-manager switch・全体テスト）が
      # 既定 2 分タイムアウト（Exit 143）で打ち切られるのを恒久的に回避する。
      # 3000000ms = 50 分。
      BASH_DEFAULT_TIMEOUT_MS = "3000000";
      BASH_MAX_TIMEOUT_MS = "3000000";
      CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = "1";
      CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
      DISABLE_AUTOUPDATER = "1";
      DISABLE_BUG_COMMAND = "1";
      DISABLE_ERROR_REPORTING = "1";
      ENABLE_TOOL_SEARCH = "true";
      CLAUDE_CODE_ENABLE_EXPERIMENTAL_ADVISOR_TOOL = "1";
    };

    permissions = {
      allow = [
        "Bash"
        "Edit"
        "ExitPlanMode"
        "Glob"
        "Grep"
        "LSP"
        "NotebookEdit"
        "Read"
        "Skill"
        "TaskCreate"
        "TaskGet"
        "TaskList"
        "TaskOutput"
        "TaskStop"
        "TaskUpdate"
        "TodoWrite"
        "ToolSearch"
        "WebSearch"
        "Write"
      ];
      deny = [
        "Bash(sudo:*)"
        "Bash(aws:*)"
        "Read(.env.*)"
        "Read(id_rsa)"
        "Read(id_ed25519)"
        "Read(**/*token*)"
        "Edit(.env*)"
        "Edit(**/secrets/**)"
        "Bash(nc:*)"
        "Bash(npm uninstall:*)"
        "Bash(npm remove:*)"
      ];
      ask = [
        "Bash(git push:*)"
        "Bash(git reset:*)"
        "Bash(git rebase:*)"
        "KillShell"
        "Bash(curl:*)"
        "Bash(wget:*)"
        "Bash(rm:*)"
        "Bash(rm -rf:*)"
        "Bash(psql:*)"
        "Bash(mysql:*)"
        "Bash(mongod:*)"
      ];
      defaultMode = "auto";
    };

    enableAllProjectMcpServers = true;

    inherit hooks;

    statusLine = {
      type = "command";
      command = "bunx ccusage statusline";
      padding = 0;
    };

    enabledPlugins = {
      # keep-sorted start
      "pyright-lsp@claude-plugins-official" = true;
      "typescript-lsp@claude-plugins-official" = true;
      "worktrunk@worktrunk" = true;
      # keep-sorted end
    };

    extraKnownMarketplaces = {
      anthropic-agent-skills.source = {
        source = "github";
        repo = "anthropics/skills";
      };
      worktrunk.source = {
        source = "github";
        repo = "max-sixty/worktrunk";
      };
    };

    outputStyle = "karakuchi";
    alwaysThinkingEnabled = false;
    effortLevel = "high";
    promptSuggestionEnabled = false;
    showClearContextOnPlanAccept = true;
    askUserQuestionTimeout = "never";
    tui = "default";
    skipWorkflowUsageWarning = true;
    editorMode = "vim";
    verbose = true;
    preferredNotifChannel = "ghostty";
    teammateMode = "auto";
    agentPushNotifEnabled = true;
    advisorModel = "fable";

    mcpServers = {
      tirith = {
        command = "tirith";
        args = [ "mcp-server" ];
      };
    };
  };

  macos = {
    permissions.allow = common.permissions.allow ++ [ "mcp__notion__notion-fetch" ];
  };

  linux = { };

  settings = lib.recursiveUpdate common (if isDarwin then macos else linux);
in
jsonFormat.generate "claude-settings.json" settings
