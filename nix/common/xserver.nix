{ pkgs, ... }: {

  imports = [
    ./sound.nix
    ./xremap.nix
    ./polkit.nix
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

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
      nerdfonts
      hackgen-nf-font
    ];
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = ["Noto Serif CJK JP" "Noto Color Emoji"];
        sansSerif = ["Noto Sans CJK JP" "Noto Color Emoji"];
        monospace = ["HackGen35 Console NF" "JetBrainsMono Nerd Font" "Noto Color Emoji"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-skk 
      fcitx5-nord
    ];
  };

}
