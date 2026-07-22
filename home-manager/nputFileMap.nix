{
  inputs,
  pkgs,
  myNurPkgs,
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

  # nput の symlink 配置はファイル/ディレクトリを区別しないため、file-map.nix の
  # homeDirMap/homeFileMap・xdgConfigDirMap/xdgConfigFileMap は各 1 つに統合する。
  homeMap = fileMap {
    dist = "";
    src = homeDir;
  };
  xdgConfigMap = fileMap {
    dist = ".config";
    src = xdgConfigHome;
  };

  # yasunori0418/skills（flake input）から Claude Code のスキルを ~/.claude/skills/<name> へ
  # 配置する。リポジトリは skills/<category>/<skill-name> 構成のため subpath を明示列挙する。
  # スキルの実体編集は ~/src/github.com/yasunori0418/skills 側で行い、
  # push + `nix flake update yasunori-skills` + switch で反映する。
  yasunoriSkillSubpaths = [
    # keep-sorted start
    # "skills/claude/latency-triage"
    "skills/claude/project-session"
    "skills/claude/response-format"
    "skills/claude/session-insights"
    "skills/claude/tmp-output"
    "skills/git/commit-flow"
    "skills/git/diff-review"
    "skills/git/parallel-worktree"
    "skills/git/rebase-flow"
    "skills/git/reset-flow"
    "skills/github/gh-ci-investigate"
    "skills/github/gh-fetch"
    "skills/github/gh-push"
    "skills/github/pr-create"
    # "skills/nix/nix-cache-check"
    "skills/nix/nix-devenv"
    "skills/product/biz-translate"
    # "skills/product/product-spec"
    "skills/testing/test-analyze"
    "skills/testing/test-design"
    "skills/testing/test-execute"
    "skills/testing/test-implement"
    "skills/testing/test-monitor"
    "skills/testing/test-plan"
    "skills/testing/test-report"
    "skills/workflow/external-writes"
    "skills/workflow/test-targeted"
    # keep-sorted end
  ];
  yasunoriSkillEntries = builtins.listToAttrs (
    map (p: {
      name = ".claude/skills/${baseNameOf p}";
      value = {
        src = inputs.yasunori-skills;
        subpath = p;
      };
    }) yasunoriSkillSubpaths
  );

  mattpocockSkillSubPaths = [
    "productivity/grilling"
    "productivity/handoff"
  ];
  mattpocockSkillEntries = builtins.listToAttrs (
    map (p: {
      name = ".claude/skills/${baseNameOf p}";
      value = {
        src = inputs.matt-skills;
        subpath = p;
      };
    }) mattpocockSkillSubPaths
  );

  # per-skill 配置のワーカーサブエージェント（diff-review / product-spec 用）を
  # ~/.claude/agents/<name>.md へ配置する。
  yasunoriAgentEntries = {
    ".claude/agents/diff-reviewer.md" = {
      src = inputs.yasunori-skills;
      subpath = "skills/git/diff-review/agents/diff-reviewer.md";
    };
    # ".claude/agents/product-researcher.md" = {
    #   src = inputs.yasunori-skills;
    #   subpath = "skills/product/product-spec/agents/product-researcher.md";
    # };
  };

  # plugin hook スクリプト（yasunori0418/skills の <subpath>/main.sh）を
  # ~/.claude/hooks/<name>/main.sh へ配置する。このマシンでは skills plugin を
  # ローカル無効にしているため hooks/hooks.json は読まれない。代わりに cchook
  # （~/.config/cchook/config.yaml）がこの配置済みスクリプトを use_stdin で呼ぶ。
  # スクリプトは flake input 由来で実行ビット付き read-only のためそのまま実行可能。
  # 二重管理を避けるため、旧 cchook/scripts 実体は廃止し本エントリを single source とする。
  #
  # 配置先 name は常に .claude/hooks/<name>（cchook が参照するパス）で固定し、
  # subpath だけがリポジトリ内の実体パスを指す。upstream の skills 再構成で
  # 汎用 hook は hook 単位のプラグイン hooks/<plugin>/hooks/<name>、skill 連動
  # hook は skills/<category>/hooks/<name> へ分かれたため、<hook 名> = <subpath>
  # の attrset で持つ（keep-sorted が 1 行 = 1 要素でソートできる形）。
  yasunoriHookSubpaths = {
    # keep-sorted start
    askuserquestion-guard = "hooks/askuserquestion/hooks/askuserquestion-guard";
    askuserquestion-notify = "hooks/askuserquestion/hooks/askuserquestion-notify";
    askuserquestion-toggle = "hooks/askuserquestion/hooks/askuserquestion-toggle";
    git-guard = "skills/git/hooks/git-guard";
    notify-stop = "hooks/notify-stop-plugin/hooks/notify-stop";
    sudo-guard = "hooks/sudo-guard-plugin/hooks/sudo-guard";
    webfetch-github-guard = "hooks/webfetch-github-guard-plugin/hooks/webfetch-github-guard";
    # keep-sorted end
  };
  yasunoriHookEntries = builtins.listToAttrs (
    builtins.attrValues (
      builtins.mapAttrs (hookName: subpath: {
        name = ".claude/hooks/${hookName}";
        value = {
          src = inputs.yasunori-skills;
          inherit subpath;
        };
      }) yasunoriHookSubpaths
    )
  );
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
  // yasunoriHookEntries;

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
      src = myNurPkgs.nvim-treesitter-parsers [
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
  };

  MacOS = {
    homeDirectory = {
      # ".docker/config.json".src = mkOutOfStoreSymlink "${homeDir}/.docker/mac_config.json";
      ".claude/settings.json".src = mkOutOfStoreSymlink "${homeDir}/.claude/settings.macos.json";
    };
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
      ".claude/settings.json".src = mkOutOfStoreSymlink "${homeDir}/.claude/settings.linux.json";
    }
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
