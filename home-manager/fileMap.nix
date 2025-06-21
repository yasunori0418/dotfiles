{
  pkgs,
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
  homeDirectory =
    {
      ".background-image".source = selectWallpaper {
        type = "default";
        name = "";
        # type = "nixos-artwork";
        # name = "nineish-solarized-dark";
      };
    }
    // homeDirMap [
      ".zsh"
      "bin"
    ]
    // homeFileMap [
      ".zshenv"
      ".zshrc"
      ".p10k.zsh"
      ".dir_colors"
      ".bashrc"
      ".bash_profile"
      ".bash_logout"
      ".screenrc"
    ];

  dotConfig =
    xdgConfigDirMap [
      "alacritty/keybinds"
      "tmux"
      "fastfetch"
      "fd"
      "git"
      "glow"
      "jj"
      "kitty"
      "nvim"
      "vim"
      "sheldon"
      "yamllint"
      "zeno"
      "wezterm"
      "direnv"
      "typos"
      "ideavim"
      "kanata"
    ]
    // xdgConfigFileMap [
      "shellcheckrc"
      "alacritty/alacritty.toml"
      "alacritty/nord.toml"
      "claude/settings.json"
      "claude/CLAUDE.md"
      "ghostty/config"
      "ghostty/core.conf"
      "ghostty/clipboard.conf"
      "ghostty/command.conf"
      "ghostty/font.conf"
      "ghostty/keybinds.conf"
      "ghostty/mouse.conf"
      "ghostty/quick.conf"
      "ghostty/resize.conf"
      "ghostty/theme.conf"
      "ghostty/window.conf"
    ];

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
      "Library/Application Support/org.Zellij-Contributors.Zellij" = {
        source = symlink /${xdgConfigHome}/zellij;
        recursive = true;
      };
      "Library/Application Support/Luacheck/.luacheckrc".source =
        symlink /${xdgConfigHome}/luacheck/.luacheckrc;
    };
    dotConfig =
      {
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
    homeDirectory =
      homeDirMap [
        ".icons"
        # ".Xresources.d"
      ]
      // homeFileMap [
        ".docker/config.json"
        ".xprofile"
        ".xinitrc"
        ".xserverrc"
        ".pam_environment"
        ".gtkrc-2.0"
        ".face"
        # ".Xresources"
      ];
    dotConfig =
      {
        ".config/alacritty/os.toml".source = symlink /${xdgConfigHome}/alacritty/linux.toml;
      }
      // xdgConfigDirMap [
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
        "zellij"
      ]
      // xdgConfigFileMap [
        "ghostty/linux.conf"
        "ncpamixer.conf"
        "screenkey.json"
        "Code/User/settings.json"
      ];
  };
}
