{
  nixos-hardware,
  xremap-flake,
  ...
}:
{
  imports =
    let
      hardwareModules = with nixos-hardware.nixosModules; [
        common-cpu-amd-zenpower
        common-gpu-nvidia-sync
        common-pc-ssd
      ];
      hardware = ./hardware-configuration.nix;
      extraMountFilesystems = ./extra-mount-filesystems.nix;
      nvidia = ../settings/nvidia.nix;

      # configuration.nix top level keys
      nix = ../settings/nix.nix;
      nixpkgs = ../settings/nixpkgs.nix;
      boot = ../settings/boot.nix;
      networking = import ../settings/networking.nix { hostName = "yasunori-desktop"; };
      environment = ../settings/environment.nix;
      time = ../settings/time.nix;
      i18n = ../settings/i18n.nix;
      security = ../settings/security.nix;
      programs = ../settings/programs.nix;
      users = ../settings/users.nix;
      fonts = ../settings/fonts.nix;
      virtualisation = ../settings/virtualisation.nix;
      qt = ../settings/qt.nix;
      sane = ../settings/hardware/sane.nix;

      services = [
        ../settings/services/printing.nix
        ../settings/services/openssh.nix
        ../settings/services/tlp.nix
        ../settings/services/displayManager/ly.nix
      ];

      xserver = [
        ../settings/xserver/base.nix
        # (import ../settings/xserver/displayManager/lightdm.nix { greeterName = "mini"; })
        ../settings/xserver/windowManager/i3wm.nix
      ];

      systemdUserServiceUnits = [
        ../settings/systemd/polkit-kde-agent.nix
        ../settings/systemd/ssh-agent.nix
      ];
      systemd-conf = ../settings/systemd/system-conf.nix;

      applications = [
        xremap-flake.nixosModules.default
        ../settings/applications/xremap.nix
        ../settings/applications/fcitx5.nix
        ../settings/applications/tailscale.nix
        ../settings/applications/pipewire.nix
        ../settings/applications/thunar.nix
        ../settings/applications/xss-i3lock.nix
        ../settings/applications/_1password.nix
      ];
    in
    [
      hardware
      extraMountFilesystems
      nvidia

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
      sane
      systemd-conf
    ]
    ++ services
    ++ xserver
    ++ systemdUserServiceUnits
    ++ hardwareModules
    ++ applications;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
