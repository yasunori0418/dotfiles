{
  config,
  nixos-hardware,
  xremap-flake,
  ...
}:
{
  imports =
    let
      lenovoThinkpadE14Amd = nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd;
      hardware = ./hardware-configuration.nix;

      # configuration.nix top level keys
      nix = ../options/nix.nix;
      nixpkgs = ../options/nixpkgs.nix;
      boot = ../options/boot.nix;
      networking = import ../options/networking.nix {
        hostName = "yasunori-laptop";
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
        ../options/services/displayManager/ly.nix
        (import ../options/services/resolved.nix { inherit config; })
      ];

      systemd = [
        ../options/systemd/system-conf.nix
        # ../options/systemd/polkit-kde-agent.nix
        ../options/systemd/ssh-agent.nix
      ];

      applications = [
        xremap-flake.nixosModules.default
        ../options/applications/xremap_wl.nix
        ../options/applications/fcitx5.nix
        ../options/applications/tailscale.nix
        ../options/applications/pipewire.nix
        ../options/applications/thunar.nix
        ../options/applications/xss-i3lock.nix
        ../options/applications/_1password.nix
        ../options/applications/sway.nix
      ];
    in
    [
      lenovoThinkpadE14Amd
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
