{
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
      nix = ../settings/nix.nix;
      nixpkgs = ../settings/nixpkgs.nix;
      boot = ../settings/boot.nix;
      networking = import ../settings/networking.nix { hostName = "yasunori-laptop"; };
      environment = ../settings/environment.nix;
      time = ../settings/time.nix;
      i18n = ../settings/i18n.nix;
      security = ../settings/security.nix;
      programs = ../settings/programs.nix;
      users = ../settings/users.nix;
      fonts = ../settings/fonts.nix;
      virtualisation = ../settings/virtualisation.nix;
      qt = ../settings/qt.nix;

      services = [
        ../settings/services/printing.nix
        ../settings/services/openssh.nix
        ../settings/services/tlp.nix
        ../settings/services/displayManager/ly.nix
      ];

      xserver = [
        ../settings/xserver/base.nix
        # (import ../settings/xserver/displayManager/lightdm.nix)
        ../settings/xserver/windowManager/i3wm.nix
      ];

      systemd = [
        ../settings/systemd/system-conf.nix
        # ../settings/systemd/polkit-kde-agent.nix
        ../settings/systemd/ssh-agent.nix
      ];

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
    ++ xserver
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
