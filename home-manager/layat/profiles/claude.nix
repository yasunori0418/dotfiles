# profile `claude`: ~/.claude/ 配下の symlink 全部
# （CLAUDE.md・output-styles・skills・agents・hooks・mcp-servers.json）。
# settings.json（copy）は recopy の影響範囲を切り離すため profiles/claude-settings.nix に置く。
# subdir = ".claude" なので entries のキーは ~/.claude からの相対で書く。
{
  pkgs,
  lib,
  inputs,
  homeDir,
  xdgConfigHome,
  fileMap,
  ...
}:
let
  yasunoriSkillEntries =
    lib.pipe
      [
        # keep-sorted start
        "skills/agent-ops/agent-teams"
        "skills/agent-ops/project-session"
        "skills/agent-ops/response-format"
        "skills/agent-ops/session-insights"
        "skills/git/commit-flow"
        "skills/git/commit-plan"
        "skills/git/diff-review"
        "skills/git/post-merge-cleanup"
        "skills/git/rebase-flow"
        "skills/git/reset-flow"
        "skills/git/review-converge"
        "skills/github/gh-ci-investigate"
        "skills/github/gh-fetch"
        "skills/github/gh-push"
        "skills/github/pr-create"
        "skills/github/pr-visualize"
        "skills/learning/navigating"
        "skills/learning/quizzing"
        "skills/learning/tutoring"
        "skills/nix/nix-devenv"
        "skills/product/biz-translate"
        "skills/workflow/external-writes"
        "skills/workflow/job-graph"
        "skills/workflow/job-plan"
        "skills/workflow/lane-ops"
        "skills/workflow/test-targeted"
        "skills/workflow/tmp-output"
        # keep-sorted end
      ]
      [
        (map (p: {
          name = "skills/${baseNameOf p}";
          value = {
            src = inputs.yasunori-skills;
            subpath = p;
          };
        }))
        builtins.listToAttrs
      ];

  mattpocockSkillEntries =
    lib.pipe
      [
        # keep-sorted start
        "skills/productivity/grilling"
        "skills/productivity/handoff"
        # keep-sorted end
      ]
      [
        (map (p: {
          name = "skills/${baseNameOf p}";
          value = {
            src = inputs.matt-skills;
            subpath = p;
          };
        }))
        builtins.listToAttrs
      ];

  # SKILL.md に textlint 併用の節を足した derivation を配置する（詳細は packages 側）。
  cojiSkillEntries = {
    "skills/natural-japanese".src = pkgs.callPackage ../../packages/natural-japanese-skill.nix {
      src = inputs.natural-japanese;
    };
  };

  # per-skill 配置のワーカーサブエージェント（diff-review / review-converge /
  # product-spec 用）を ~/.claude/agents/<name>.md へ配置する。
  # skills 側で agents/*.md が増えてもここは手動登録なので、flake input を
  # 更新したら追随漏れが無いか突き合わせる。
  yasunoriAgentEntries = {
    "agents/diff-reviewer.md" = {
      src = inputs.yasunori-skills;
      subpath = "skills/git/diff-review/agents/diff-reviewer.md";
    };
    # "agents/product-researcher.md" = {
    #   src = inputs.yasunori-skills;
    #   subpath = "skills/product/product-spec/agents/product-researcher.md";
    # };
    "agents/review-aggregator.md" = {
      src = inputs.yasunori-skills;
      subpath = "skills/git/review-converge/agents/review-aggregator.md";
    };
  };

  # hook の一覧は settings.json 側（profiles/claude-settings.nix → claudeHooks.nix）と
  # 共有するため ../claude-hook-subpaths.nix に置く。
  yasunoriHookEntries = lib.mapAttrs' (hookName: subpath: {
    name = "hooks/${hookName}";
    value = {
      src = inputs.yasunori-skills;
      inherit subpath;
    };
  }) (import ../claude-hook-subpaths.nix);

  # tirith 公式リポジトリの hook スクリプトを ~/.claude/hooks/tirith/ 配下へ
  # 単ファイル symlink として配置。settings.json の PreToolUse hook（claudeHooks.nix）から
  # `uv run --python 3.13 -- $HOME/.claude/hooks/tirith/tirith-check.py` として
  # 呼び出す（python バージョンを uv で固定）。
  tirithHookEntries = {
    "hooks/tirith/tirith-check.py" = {
      src = inputs.tirith;
      subpath = "crates/tirith/assets/hooks/tirith-check.py";
    };
  };

  # Claude Code の user スコープへ登録する MCP サーバー定義（詳細は claudeMcpServers.nix）。
  # Claude Code 自身はこのファイルを読まない。scripts/claude-mcp-register.sh の入力。
  claudeMcpServersEntry = {
    "mcp-servers.json".src = import ../../claudeMcpServers.nix {
      inherit pkgs;
      # MCP サーバーの引数は layat の src ではないため、"~/" 始まりで渡して
      # scripts/claude-mcp-register.sh に登録時に $HOME へ展開させる。
      textlintConfig = "~/${xdgConfigHome}/textlint/.textlintrc.json";
    };
  };

  # herdr の Claude Code 統合（hook と skill）。配置先が ~/.claude/ 配下なので
  # profile は claude（herdr-plugins ではない）。
  herdrEntries = {
    "hooks/herdr/herdr-agent-state.sh" = {
      src = inputs.herdr;
      subpath = "src/integration/assets/claude/herdr-agent-state.sh";
    };
    "skills/herdr" = {
      src = inputs.herdr;
      subpath = "skills/herdr";
    };
  };
in
{
  subdir = ".claude";
  common =
    fileMap
      {
        dist = "";
        src = "${homeDir}/.claude";
      }
      [
        "CLAUDE.md"
        "output-styles"
      ]
    // mattpocockSkillEntries
    // cojiSkillEntries
    // yasunoriSkillEntries
    // yasunoriAgentEntries
    // yasunoriHookEntries
    // tirithHookEntries
    // claudeMcpServersEntry
    // herdrEntries;
  MacOS = { };
  Linux = { };
}
