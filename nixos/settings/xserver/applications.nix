{ pkgs, ... }:
{
  systemThemeTools = with pkgs; [
    themechanger
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugins
  ];

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
    peek
    simplescreenrecorder
    font-manager
  ];

  xfceTools = with pkgs.xfce; [
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
