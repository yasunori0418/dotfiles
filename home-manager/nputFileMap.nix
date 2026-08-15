{
  inputs,
  pkgs,
  homeDir,
  xdgConfigHome,
  mkOutOfStoreSymlink,
  ...
}:
let
  inherit (import ./lib/nput-file-map.nix { inherit pkgs mkOutOfStoreSymlink homeDir; })
    selectWallpaper
    fileMap
    ;

  inherit (pkgs) lib;

  # GTK4 はテーマディレクトリを検索せず ~/.config/gtk-4.0/gtk.css しか読まないため、
  # applications.nix と同じ derivation から css を store-backed で配置する。
  nordic-darker = pkgs.callPackage ./packages/nordic-darker.nix { };

  # nput の symlink 配置はファイル/ディレクトリを区別しないため、旧 home.file 実装が
  # 持っていた homeDirMap/homeFileMap・xdgConfigDirMap/xdgConfigFileMap は各 1 つに統合する。
  homeMap = fileMap {
    dist = "";
    src = homeDir;
  };
  xdgConfigMap = fileMap {
    dist = ".config";
    src = xdgConfigHome;
  };

  # treesitter パーサーを nixpkgs（dotfiles 自身の pin）の
  # vimPlugins.nvim-treesitter-parsers から symlinkJoin で束ねる。
  # クエリは dpp 管理の nvim-treesitter checkout 側を使う
  # （hooks/treesitter.lua の initialize() が install_dir へ symlink）ため配置しない。
  # パーサーの更新は `nix flake update nixpkgs` + switch。
  nvimTreesitterParsers =
    parsers:
    pkgs.symlinkJoin {
      name = "nvim-treesitter-parsers";
      paths = map (parser: pkgs.vimPlugins.nvim-treesitter-parsers.${parser}) parsers;
    };

  yasunoriSkillEntries =
    lib.pipe
      [
        # keep-sorted start
        "skills/claude/project-session"
        "skills/claude/response-format"
        "skills/claude/session-insights"
        "skills/claude/tmp-output"
        "skills/git/commit-flow"
        "skills/git/commit-plan"
        "skills/git/diff-review"
        "skills/git/parallel-worktree"
        "skills/git/post-merge-cleanup"
        "skills/git/rebase-flow"
        "skills/git/reset-flow"
        "skills/git/review-converge"
        "skills/github/gh-ci-investigate"
        "skills/github/gh-fetch"
        "skills/github/gh-push"
        "skills/github/pr-create"
        "skills/learning/navigating"
        "skills/learning/quizzing"
        "skills/learning/tutoring"
        # "skills/nix/nix-cache-check"
        "skills/nix/nix-devenv"
        "skills/product/basic-design"
        "skills/product/biz-translate"
        "skills/product/def-done"
        "skills/product/doc-integrate"
        "skills/product/feature-spec"
        "skills/product/product-spec"
        "skills/testing/test-analyze"
        "skills/testing/test-design"
        "skills/testing/test-execute"
        "skills/testing/test-implement"
        "skills/testing/test-monitor"
        "skills/testing/test-plan"
        "skills/testing/test-report"
        "skills/testing/test-review"
        "skills/workflow/dev-pipeline"
        "skills/workflow/external-writes"
        "skills/workflow/job-graph"
        "skills/workflow/lane-ops"
        "skills/workflow/test-targeted"
        # keep-sorted end
      ]
      [
        (map (p: {
          name = ".claude/skills/${baseNameOf p}";
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
          name = ".claude/skills/${baseNameOf p}";
          value = {
            src = inputs.matt-skills;
            subpath = p;
          };
        }))
        builtins.listToAttrs
      ];

  # per-skill 配置のワーカーサブエージェント（diff-review / product-spec 用）を
  # ~/.claude/agents/<name>.md へ配置する。
  yasunoriAgentEntries = {
    ".claude/agents/diff-reviewer.md" = {
      src = inputs.yasunori-skills;
      subpath = "skills/git/diff-review/agents/diff-reviewer.md";
    };
    ".claude/agents/test-reviewer.md" = {
      src = inputs.yasunori-skills;
      subpath = "skills/testing/test-review/agents/test-reviewer.md";
    };
    ".claude/agents/product-researcher.md" = {
      src = inputs.yasunori-skills;
      subpath = "skills/product/product-spec/agents/product-researcher.md";
    };
  };

  yasunoriHookSubpaths = {
    # keep-sorted start
    askuserquestion-guard = "hooks/askuserquestion/hooks/askuserquestion-guard";
    askuserquestion-notify = "hooks/askuserquestion/hooks/askuserquestion-notify";
    askuserquestion-toggle = "hooks/askuserquestion/hooks/askuserquestion-toggle";
    git-guard = "skills/git/hooks/git-guard";
    notify-stop = "hooks/notify-stop-plugin/hooks/notify-stop";
    sudo-guard = "hooks/sudo-guard-plugin/hooks/sudo-guard";
    task-boundary = "hooks/task-boundary-plugin/hooks/task-boundary";
    teammate-leak-guard = "hooks/teammate-leak-guard-plugin/hooks/teammate-leak-guard";
    webfetch-github-guard = "hooks/webfetch-github-guard-plugin/hooks/webfetch-github-guard";
    # keep-sorted end
  };
  yasunoriHookEntries = lib.mapAttrs' (hookName: subpath: {
    name = ".claude/hooks/${hookName}";
    value = {
      src = inputs.yasunori-skills;
      inherit subpath;
    };
  }) yasunoriHookSubpaths;

  # tirith 公式リポジトリの hook スクリプトを ~/.claude/hooks/tirith/ 配下へ
  # 単ファイル symlink として配置。cchook 側から
  # `uv run --python 3.13 -- $HOME/.claude/hooks/tirith/tirith-check.py` として
  # 呼び出す（python バージョンを uv で固定）。
  tirithHookEntries = {
    ".claude/hooks/tirith/tirith-check.py" = {
      src = inputs.tirith;
      subpath = "crates/tirith/assets/hooks/tirith-check.py";
    };
  };

  herdrEntries = {
    ".claude/hooks/herdr/herdr-agent-state.sh" = {
      src = inputs.herdr;
      subpath = "src/integration/assets/claude/herdr-agent-state.sh";
    };
    ".claude/skills/herdr" = {
      src = inputs.herdr;
      subpath = "skills/herdr";
    };
  };

  /*
    herdr プラグイン本体。derivation の $out がそのまま plugin_root になる
    （$out 直下に herdr-plugin.toml が居る形へ各 package 側で整形済み）。

    配置しただけでは herdr は認識しない。herdr はプラグインをディレクトリ
    走査で発見せず ~/.config/herdr/plugins.json への登録を見るため、配置後に
    `herdr plugin link <dir>` が要る（scripts/herdr-plugin-link.sh が担い、
    switch 時の activation と `make herdr-plugin-link` の両方から呼ぶ）。

    link は渡されたパスを canonicalize して実体（= store パス）を記録するので、
    plugins.json には /nix/store/... が入る。プラグインを更新すると store パスが
    変わり登録が stale になるため、link は switch のたびに再実行する
    （同一 plugin_id は上書きされる冪等操作）。
  */
  herdrPluginEntries = {
    ".local/share/herdr-plugins/worktrunk".src = pkgs.callPackage ./packages/herdr-worktrunk.nix {
      src = inputs.herdr-worktrunk;
    };
    ".local/share/herdr-plugins/navigator".src = pkgs.callPackage ./packages/herdr-navigator.nix {
      src = inputs.herdr-navigator;
    };
    ".local/share/herdr-plugins/plus".src = pkgs.callPackage ./packages/herdr-plus.nix {
      src = inputs.herdr-plus;
    };
  };

  /*
    ~/.claude/settings.json は Nix attrset から生成した JSON を copy で配置する。

    symlink（store 直結）だと Claude Code の TUI / `/config` による書き戻し
    （effortLevel・outputStyle・enabledPlugins 等）が read-only で失敗するため
    method = "copy" にする。nput の copy は store の read-only モードに
    owner-write を加えて配置するので書き戻せる。

    copy は place-once なので、claudeSettings.nix を編集しただけでは
    switch で反映されない。反映には `nput apply --recopy` が要る。
  */
  claudeSettingsEntry = isDarwin: {
    ".claude/settings.json" = {
      src = import ./claudeSettings.nix { inherit pkgs isDarwin; };
      method = "copy";
    };
  };
in
{
  homeDirectory = {
    ".background-image" = selectWallpaper {
      type = "default";
      name = "";
      # type = "nixos-artwork";
      # name = "nineish-solarized-dark";
    };
  }
  // homeMap [
    # keep-sorted start
    ".bash_logout"
    ".bash_profile"
    ".bashrc"
    ".claude/CLAUDE.md"
    ".claude/output-styles"
    ".dir_colors"
    ".p10k.zsh"
    ".screenrc"
    ".zsh"
    ".zshenv"
    ".zshrc"
    "bin"
    # keep-sorted end
  ]
  // mattpocockSkillEntries
  // yasunoriSkillEntries
  // yasunoriAgentEntries
  // yasunoriHookEntries
  // tirithHookEntries
  // herdrEntries;

  dotConfig = xdgConfigMap [
    # keep-sorted start
    "alacritty/alacritty.toml"
    "alacritty/keybinds"
    "alacritty/nord.toml"
    "cchook"
    "clipcat"
    "direnv"
    "dpp"
    "fastfetch"
    "fd"
    "ghostty/clipboard.conf"
    "ghostty/command.conf"
    "ghostty/config"
    "ghostty/core.conf"
    "ghostty/font.conf"
    "ghostty/keybinds.conf"
    "ghostty/mouse.conf"
    "ghostty/quick.conf"
    "ghostty/resize.conf"
    "ghostty/theme.conf"
    "ghostty/window.conf"
    "git"
    "glow"
    "gwq"
    "herdr/config.toml"
    "herdr/plugins/config/herdr-navigator/config.toml"
    "ideavim"
    "jj"
    "kanata"
    "kitty"
    "laminate"
    "nvim"
    "ov"
    "sheldon"
    "shellcheckrc"
    "sqls"
    "tirith"
    "tmux"
    "typos"
    "vim"
    "wezterm"
    "worktrunk"
    "yamllint"
    "zellij"
    "zeno"
    # keep-sorted end
  ];

  # treesitter parser だけは ~/dotfiles ではなく nix store 由来のため、out-of-store
  # symlink ではなく store-backed src（derivation + subpath）で配置する。
  dotLocalShare = {
    ".local/share/nvim/treesitter/parser" = {
      src = nvimTreesitterParsers [
        # keep-sorted start
        "bash"
        "comment"
        "css"
        "csv"
        "diff"
        "dockerfile"
        "fish"
        "git_config"
        "git_rebase"
        "gitattributes"
        "gitcommit"
        "gitignore"
        "html"
        "jsdoc"
        "json"
        "json5"
        # "jsonc"
        "kdl"
        "kotlin"
        "lua"
        "luadoc"
        "make"
        "markdown"
        "markdown_inline"
        "nix"
        "python"
        "regex"
        "ron"
        "rust"
        "sql"
        "sway"
        "toml"
        "tsv"
        "typescript"
        "vim"
        "vimdoc"
        "xml"
        "yaml"
        # keep-sorted end
      ];
      subpath = "parser";
    };
  }
  // herdrPluginEntries;

  MacOS = {
    homeDirectory = {
      # ".docker/config.json".src = mkOutOfStoreSymlink "${homeDir}/.docker/mac_config.json";
    }
    // claudeSettingsEntry true;
    library = {
      "Library/Application Support/AquaSKK".src =
        mkOutOfStoreSymlink "${homeDir}/Library/ApplicationSupport/AquaSKK";
      "Library/Application Support/arto".src = mkOutOfStoreSymlink "${xdgConfigHome}/arto";
      "Library/Application Support/Code/User/settings.json".src =
        mkOutOfStoreSymlink "${xdgConfigHome}/Code/User/settings.json";
      "Library/Application Support/Luacheck/.luacheckrc".src =
        mkOutOfStoreSymlink "${xdgConfigHome}/luacheck/.luacheckrc";
    };
    dotConfig = {
      ".config/alacritty/os.toml".src = mkOutOfStoreSymlink "${xdgConfigHome}/alacritty/mac.toml";
    }
    // xdgConfigMap [
      "ghostty/macos.conf"
      "aerospace"
      "karabiner"
    ];
  };

  Linux = {
    homeDirectory = {
      ".docker/config.json".src = mkOutOfStoreSymlink "${homeDir}/.docker/linux_config.json";
    }
    // claudeSettingsEntry false
    // homeMap [
      ".icons"
      ".face"
      ".gtkrc-2.0"
      ".pam_environment"
      ".xinitrc"
      ".xprofile"
      ".xserverrc"
      # ".Xresources"
      # ".Xresources.d"
    ];
    dotConfig = {
      ".config/alacritty/os.toml".src = mkOutOfStoreSymlink "${xdgConfigHome}/alacritty/linux.toml";

      # themechanger / nwg-look が野良で張っていた symlink を nput 管理下に取り込む。
      # ~/dotfiles ではなく nix store 由来のため store-backed src で配置する。
      ".config/gtk-4.0/gtk.css" = {
        src = nordic-darker;
        subpath = "share/themes/Nordic-darker/gtk-4.0/gtk.css";
      };
      ".config/gtk-4.0/gtk-dark.css" = {
        src = nordic-darker;
        subpath = "share/themes/Nordic-darker/gtk-4.0/gtk-dark.css";
      };
    }
    // xdgConfigMap [
      # keep-sorted start
      "Code/User/settings.json"
      "arto"
      "bumblebee-status"
      "cantata"
      "dunst"
      "environment.d/my-env.conf"
      "fcitx5"
      "ghostty/linux.conf"
      "gtk-2.0"
      "gtk-3.0"
      "gtk-4.0/settings.ini"
      "i3status-rust"
      "keynav"
      "libskk"
      "luacheck"
      "mpd"
      "ncpamixer.conf"
      "niri"
      "paru"
      "picom"
      "rofi"
      "screenkey.json"
      "sway"
      "swayidle"
      "swaylock"
      "xremap"
      # keep-sorted end
    ];
  };
}
