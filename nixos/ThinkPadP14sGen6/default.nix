{
  pkgs,
  xremap-flake,
  ...
}:
{
  imports =
    let
      hardware = ./hardware-configuration.nix;

      # configuration.nix top level keys
      nix = ../options/nix.nix;
      nixpkgs = ../options/nixpkgs.nix;
      boot = ../options/boot.nix;
      networking = import ../options/networking.nix {
        hostName = "yasunori-laptop2";
        wifi-power-save = true;
      };
      environment = ../options/environment.nix;
      time = ../options/time.nix;
      i18n = ../options/i18n.nix;
      security = ../options/security.nix;
      programs = ../options/programs.nix;
      users = ../options/users.nix;
      fonts = ../options/fonts.nix;
      virtualisation = ../options/virtualisation.nix;
      qt = ../options/qt.nix;

      services = [
        ../options/services/printing.nix
        ../options/services/openssh.nix
        ../options/services/tlp.nix
        # ../options/services/displayManager/ly.nix
        ../options/services/displayManager/lemurs.nix
        ../options/services/resolved.nix
      ];

      systemd = [
        ../options/systemd/system-conf.nix
        # ../options/systemd/polkit-kde-agent.nix
        ../options/systemd/ssh-agent.nix
        ../options/systemd/clipcatd.nix
        ../options/systemd/initial-dotfiles.nix
      ];

      applications = [
        xremap-flake.nixosModules.default
        ../options/applications/xremap.nix
        ../options/applications/fcitx5.nix
        ../options/applications/tailscale.nix
        ../options/applications/pipewire.nix
        ../options/applications/thunar.nix
        # ../options/applications/xss-i3lock.nix
        ../options/applications/_1password.nix
        ../options/applications/sway.nix
        # ../options/applications/niri.nix
      ];
    in
    [
      hardware

      # configuration.nix top level keys
      nix
      nixpkgs
      boot
      networking
      environment
      time
      i18n
      security
      programs
      users
      fonts
      virtualisation
      qt
    ]
    ++ services
    ++ systemd
    ++ applications;

  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # VA-API用 (iHDドライバ)
        intel-vaapi-driver # 古いアプリケーション用
        libvdpau-va-gl
        vpl-gpu-rt # Intel Arc/12世代以降のQuick Sync (QSV) 用
        intel-compute-runtime # OpenCL用
      ];
    };
  };

  environment.sessionVariables = {
    # VA-APIドライバの指定
    LIBVA_DRIVER_NAME = "iHD";
    # Waylandを使用する場合、Electronアプリ等の安定性を向上
    NIXOS_OZONE_WL = "1";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
