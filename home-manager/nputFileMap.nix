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
  # 配置する。リポジトリは <category>/<skill-name> 構成のため subpath を明示列挙する。
  # スキルの実体編集は ~/src/github.com/yasunori0418/skills 側で行い、
  # push + `nix flake update yasunori-skills` + switch で反映する。
  yasunoriSkillSubpaths = [
    # keep-sorted start
    "claude/external-writes"
    "claude/latency-triage"
    "claude/response-format"
    "claude/session-insights"
    "claude/test-targeted"
    "claude/tmp-output"
    "git/commit-flow"
    "git/diff-review"
    "git/parallel-worktree"
    "git/rebase-flow"
    "git/reset-flow"
    "github/gh-ci-investigate"
    "github/gh-fetch"
    "github/gh-push"
    "github/pr-create"
    "nix/nix-cache-check"
    "nix/nix-devenv"
    "product/biz-translate"
    "product/product-spec"
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

  # per-skill 配置のワーカーサブエージェント（diff-review / product-spec 用）を
  # ~/.claude/agents/<name>.md へ配置する。
  yasunoriAgentEntries = {
    ".claude/agents/diff-reviewer.md" = {
      src = inputs.yasunori-skills;
      subpath = "git/diff-review/agents/diff-reviewer.md";
    };
    ".claude/agents/product-researcher.md" = {
      src = inputs.yasunori-skills;
      subpath = "product/product-spec/agents/product-researcher.md";
    };
  };

  # plugin hook スクリプト（yasunori0418/skills の hooks/scripts/<name>/main.sh）を
  # ~/.claude/hooks/<name>/main.sh へ配置する。このマシンでは skills plugin を
  # ローカル無効にしているため hooks/hooks.json は読まれない。代わりに cchook
  # （~/.config/cchook/config.yaml）がこの配置済みスクリプトを use_stdin で呼ぶ。
  # スクリプトは flake input 由来で実行ビット付き read-only のためそのまま実行可能。
  # 二重管理を避けるため、旧 cchook/scripts 実体は廃止し本エントリを single source とする。
  yasunoriHookEntries = builtins.listToAttrs (
    map (hook: {
      name = ".claude/${hook}";
      value = {
        src = inputs.yasunori-skills;
        subpath = hook;
      };
    }) [
      # keep-sorted start
      "hooks/askuserquestion-guard"
      "hooks/askuserquestion-toggle"
      "hooks/git-guard"
      "hooks/notify-stop"
      "hooks/sudo-guard"
      "hooks/webfetch-github-guard"
      # keep-sorted end
    ]
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
