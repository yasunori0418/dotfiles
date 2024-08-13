{ pkgs, ... }: {

  imports = [
    ./sound.nix
    ./xremap.nix
    ./polkit.nix
    ./font.nix
    ./fcitx5.nix
  ];

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Configure keymap in X11
    xkb.layout = "us";

    # Enable the XFCE Desktop Environment.
    displayManager.lightdm.enable = true;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3status
        # bumblebee-status
        gparted
        slack
        arandr
        google-chrome
        discord
        rofi
        rofi-power-menu
        feh
        picom
        blueberry
        dunst
        clipmenu
        nordic
        nordzy-icon-theme
        nordzy-cursor-theme
        gtk4
        gtk3
        themechanger
        ncpamixer
      ]
        ++(with pkgs.libsForQt5; [
          qt5.qtbase
          qt5ct
          qtstyleplugins
        ])
        ++(with pkgs.xfce; [
          xfce4-power-manager
          thunar
          thunar-volman
          xfce4-screenshooter
        ])
      ;
    };
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

}
