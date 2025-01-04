{
  pkgs,
  config,
  homeDir,
  xdgConfigHome,
  ...
}:
let
  symlink = config.lib.file.mkOutOfStoreSymlink;
  selectWallpaper =
    {
      ## type = (nixos-artwork | (default | null))
      type,

      ## type is `nixos-artwork` then select from nixos-artwork.
      ## mean name: nix-wallpaper-${name}.png
      ## refer: https://github.com/NixOS/nixos-artwork/tree/master/wallpapers
      #
      ## type is default or null then must be set any value.
      ## e.g. name = "";
      name,
    }:
    if type == "nixos-artwork" then
      "${pkgs.nixos-artwork.wallpapers.${name}}/share/backgrounds/nixos/nix-wallpaper-${name}.png"
    else
      (symlink /${homeDir}/.background-image);

  /*
    ファイル/ディレクトリ配置をいい感じにマップする
    ```
    ".config/hoge/conf" = {
      source = symlink /${xdgConfigHome}/conf;
      recursive = true;
    };
    ```
    ↑こういう記述が連続するのを減らせる
    配置元と配置先の命名が一致しているときだけ使える

    dist: 配置先
    src: dotfiles上のファイルパス
    is_recursive: ディレクトリを配置するときはtrue、ファイルを配置するときはfalse
    return: ファイル名のリストが引数となる関数
  */
  fileMap =
    {
      dist,
      src,
      is_recursive,
    }:
    let
      f =
        files:
        builtins.foldl' (acc: elem: acc // elem) { } (
          map (
            file:
            let
              distFile = if dist == "" then "${file}" else "${dist}/${file}";
            in
            {
              ${distFile} = {
                source = symlink /${src}/${file};
                recursive = is_recursive;
              };
            }
          ) files
        );
    in
    f;

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
      ".textlintrc.yaml"
      ".dir_colors"
      ".bashrc"
      ".bash_profile"
      ".bash_logout"
      "package.json"
      ".screenrc"
    ];

  dotConfig =
    xdgConfigDirMap [
      "alacritty/keybinds"
      "tmux"
      "fastfetch"
      "fd"
      "git"
      "jj"
      "kitty"
      "luacheck"
      "neofetch"
      "nvim"
      "vim"
      "sheldon"
      "yamllint"
      "zeno"
      "wezterm"
      "direnv"
    ]
    // xdgConfigFileMap [
      "alacritty/alacritty.toml"
      "alacritty/nord.toml"
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
      ".docker/config.json".source = symlink /${homeDir}/.docker/mac_config.json;
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
        "sketchybar"
        "skhd"
        "yabai"
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
        "keynav"
        "libskk"
        "mpd"
        "paru"
        "picom"
        "rofi"
        "systemd"
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
