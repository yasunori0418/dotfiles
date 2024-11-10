{ pkgs, ... }:
{
  systemThemeTools =
    with pkgs;
    [
      gtk4
      gtk3
      themechanger
    ]
    ++ (with pkgs.libsForQt5; [
      qt5.qtbase
      qt5ct
      qtstyleplugins
    ]);

  nordThemePkgs = with pkgs; [
    nordic
    nordzy-icon-theme
    nordzy-cursor-theme
  ];

  desktopTools = with pkgs; [
    gparted
    slack
    arandr
    google-chrome
    discord
    blueberry
    pavucontrol
    gthumb
  ];

  xfceTools = with pkgs.xfce; [
    xfce4-power-manager
    xfce4-screenshooter
  ];

  otherTools = with pkgs; [
    rofi
    rofi-power-menu
    feh
    picom
    dunst
    clipmenu
    ncpamixer
    xsel
  ];
}
