# profile `desktop`: WM・GUI・テーマ・入力メソッド・壁紙（nixpkgs 由来の gtk css を含む）。
{
  pkgs,
  homeDir,
  mkRootRelativeSymlink,
  homeMap,
  xdgConfigMap,
  selectWallpaper,
  ...
}:
let
  # GTK4 はテーマディレクトリを検索せず ~/.config/gtk-4.0/gtk.css しか読まないため、
  # applications.nix と同じ derivation から css を store-backed で配置する。
  nordic-darker = pkgs.callPackage ../../packages/nordic-darker.nix { };
in
{
  common = {
    ".background-image" = selectWallpaper {
      type = "default";
      name = "";
      # type = "nixos-artwork";
      # name = "nineish-solarized-dark";
    };
  };
  MacOS = {
    "Library/Application Support/AquaSKK".src =
      mkRootRelativeSymlink "${homeDir}/Library/ApplicationSupport/AquaSKK";
  }
  // xdgConfigMap [
    "aerospace"
    "karabiner"
  ];
  Linux = {
    # themechanger / nwg-look が野良で張っていた symlink を layat 管理下に取り込む。
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
  // homeMap [
    # keep-sorted start
    ".face"
    ".gtkrc-2.0"
    ".icons"
    ".xinitrc"
    ".xprofile"
    ".xserverrc"
    # ".Xresources"
    # ".Xresources.d"
    # keep-sorted end
  ]
  // xdgConfigMap [
    # keep-sorted start
    "bumblebee-status"
    "cantata"
    "dunst"
    "fcitx5"
    "gtk-2.0"
    "gtk-3.0"
    "gtk-4.0/settings.ini"
    "i3status-rust"
    "keynav"
    "libskk"
    "mpd"
    "ncpamixer.conf"
    "picom"
    "rofi"
    "screenkey.json"
    "sway"
    "swayidle"
    "swaylock"
    "xremap"
    # keep-sorted end
  ];
}
