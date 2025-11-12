{
  pkgs,
  myNurPkgs,
  config,
  homeDir,
  xdgConfigHome,
  ...
}:
let
  symlink = config.lib.file.mkOutOfStoreSymlink;
  inherit (import ./lib/file-map.nix { inherit pkgs symlink homeDir; })
    selectWallpaper
    fileMap
    ;

  homeFileMap = fileMap {
    dist = "";
    src = homeDir;
    is_recursive = false;
  };
  homeDirMap = fileMap {
    dist = "";
    src = homeDir;
    is_recursive = true;
  };
  xdgConfigFileMap = fileMap {
    dist = ".config";
    src = xdgConfigHome;
    is_recursive = false;
  };
  xdgConfigDirMap = fileMap {
    dist = ".config";
    src = xdgConfigHome;
    is_recursive = true;
  };
in
{
  homeDirectory = {
    ".background-image".source = selectWallpaper {
      type = "default";
      name = "";
      # type = "nixos-artwork";
      # name = "nineish-solarized-dark";
    };
  }
  // homeDirMap [
    # keep-sorted start
    ".claude/agents"
    ".claude/commands"
    ".zsh"
    "bin"
    # keep-sorted end
  ]
  // homeFileMap [
    # keep-sorted start
    ".bash_logout"
    ".bash_profile"
    ".bashrc"
    ".claude/CLAUDE.md"
    ".claude/settings.json"
    ".dir_colors"
    ".p10k.zsh"
    ".screenrc"
    ".zshenv"
    ".zshrc"
    # keep-sorted end
  ];

  dotConfig =
    xdgConfigDirMap [
      # keep-sorted start
      "alacritty/keybinds"
      "cchook"
      "direnv"
      "dpp"
      "fastfetch"
      "fd"
      "git"
      "glow"
      "gwq"
      "ideavim"
      "jj"
      "kanata"
      "kitty"
      "laminate"
      "nvim"
      "sheldon"
      "sqls"
      "tmux"
      "typos"
      "vim"
      "wezterm"
      "yamllint"
      "zellij"
      "zeno"
      # keep-sorted end
    ]
    // xdgConfigFileMap [
      # keep-sorted start
      "alacritty/alacritty.toml"
      "alacritty/nord.toml"
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
      "shellcheckrc"
      # keep-sorted end
    ];

  dotLocalShare = {
    ".local/share/nvim/treesitter/parser".source = builtins.toString "/${
      myNurPkgs.nvim-treesitter-parsers [
        # keep-sorted start
        "bash"
        "css"
        "diff"
        "dockerfile"
        "git_config"
        "git_rebase"
        "gitattributes"
        "gitcommit"
        "gitignore"
        "html"
        "jsdoc"
        "json"
        "json5"
        "jsonc"
        "kdl"
        "kotlin"
        "lua"
        "luadoc"
        "make"
        "markdown"
        "markdown_inline"
        "nix"
        "toml"
        "typescript"
        "vim"
        "vimdoc"
        "xml"
        "yaml"
        # keep-sorted end
      ]
    }/parser";
  };

  MacOS = {
    homeDirectory = {
      # ".docker/config.json".source = symlink /${homeDir}/.docker/mac_config.json;
    };
    library = {
      "Library/Application Support/AquaSKK" = {
        source = symlink /${homeDir}/Library/ApplicationSupport/AquaSKK;
        recursive = true;
      };
      "Library/Application Support/Code/User/settings.json".source =
        symlink /${xdgConfigHome}/Code/User/settings.json;
      "Library/Application Support/Luacheck/.luacheckrc".source =
        symlink /${xdgConfigHome}/luacheck/.luacheckrc;
    };
    dotConfig = {
      ".config/alacritty/os.toml".source = symlink /${xdgConfigHome}/alacritty/mac.toml;
    }
    // xdgConfigDirMap [
      "ghostty/macos.conf"
    ]
    // xdgConfigDirMap [
      "aerospace"
      "karabiner"
    ];
  };

  Linux = {
    homeDirectory = {
      ".docker/config.json".source = symlink /${homeDir}/.docker/linux_config.json;
    }
    // homeDirMap [
      ".icons"
      # ".Xresources.d"
    ]
    // homeFileMap [
      # keep-sorted start
      ".face"
      ".gtkrc-2.0"
      ".pam_environment"
      ".xinitrc"
      ".xprofile"
      ".xserverrc"
      # ".Xresources"
      # keep-sorted end
    ];
    dotConfig = {
      ".config/alacritty/os.toml".source = symlink /${xdgConfigHome}/alacritty/linux.toml;
    }
    // xdgConfigDirMap [
      # keep-sorted start
      "bumblebee-status"
      "cantata"
      "dunst"
      "fcitx5"
      "gtk-2.0"
      "gtk-3.0"
      "i3"
      "i3status-rust"
      "keynav"
      "libskk"
      "luacheck"
      "mpd"
      "paru"
      "picom"
      "rofi"
      "xremap"
      # keep-sorted end
    ]
    // xdgConfigFileMap [
      # keep-sorted start
      "Code/User/settings.json"
      "ghostty/linux.conf"
      "ncpamixer.conf"
      "screenkey.json"
      # keep-sorted end
    ];
  };
}
