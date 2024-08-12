# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = let
    mySystemSettings = import ../common/system.nix { inherit pkgs; hostName = "yasunori-laptop"; };
  in
  [
    mySystemSettings
  ];

  services = {
    xserver = {
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
            polkit-qt
          ]);
      };

      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  security.polkit.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yasunori = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "yasunori";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      git
      wezterm
      deno
      gnumake
      gcc
      clang
      zig
      ncurses
      xsel
    ];
  };

  programs = {
    zsh.enable = true;
    noisetorch.enable = true;
    nix-ld = {
      enable = true;
      # libraries = with pkgs; [];
    };
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

  /* Run a single one-shot service that allows root's services to access user's X session */
  systemd.user.services.set-xhost = {
    description = "Run a one-shot command upon user login";
    path = [ pkgs.xorg.xhost ];
    wantedBy = [ "default.target" ];
    script = "xhost +SI:localuser:root";
    environment.DISPLAY = ":0.0"; # NOTE: This is hardcoded for this flake
  };

  services.xremap = {
    withX11 = true;
    config = {
      modmap = [
        {
          name = "Swapping Capslock and Ctrl_L";
          remap = {
            Capslock = "Ctrl_L";
            Ctrl_L = "Capslock";
          };
          device = {
            not = [ "HHKB" ];
          };
        }
      ];
      keymap = [
        {
          name = "Slightly emacs-like keymap.";
          remap = {
            C-h = "Backspace";
            C-a = "home";
            C-e = "end";
            C-f = "right";
            C-b = "left";
            C-p = "up";
            C-n = "down";
            C-m = "enter";
          };
          application = {
            not = [ "/wezterm/" ];
          };
          device = {
            not = [];
          };
        }
      ];
    };
  };

  services.tailscale.enable = true;
  networking.firewall = {
    # tailscaleの仮想NICを信頼する
    # `<Tailscaleのホスト名>:<ポート番号>`のアクセスが可能になる
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };


  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
