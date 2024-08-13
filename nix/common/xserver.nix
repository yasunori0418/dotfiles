{ pkgs, ... }: {
  services.xserver = {
    enable = true; # Enable the X11 windowing system.

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
        lightlocker
        clipmenu
        xfce.xfce4-power-manager
        xfce.thunar
        xfce.thunar-volman
        xfce.xfce4-screenshooter
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
          polkit-kde-agent
        ]);
    };

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

}
