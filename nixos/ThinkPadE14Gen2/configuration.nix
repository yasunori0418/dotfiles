{ pkgs, nixosModules, ... }:
let
  hardware = ./hardware-configuration.nix;

  # configuration.nix top level keys
  nix = /${nixosModules}/nix.nix;
  boot = /${nixosModules}/boot.nix;
  networking = import /${nixosModules}/networking.nix { hostName = "yasunori-laptop"; };
  environment = /${nixosModules}/environment.nix;
  time = /${nixosModules}/time.nix;
  i18n = /${nixosModules}/i18n.nix;
  security = /${nixosModules}/security.nix;
  programs = /${nixosModules}/programs.nix;
  users = /${nixosModules}/users.nix;
  fonts = /${nixosModules}/fonts.nix;
  virtualisation = /${nixosModules}/virtualisation.nix;
  qt = /${nixosModules}/qt.nix;

  services = [
    /${nixosModules}/services/printing.nix
    /${nixosModules}/services/openssh.nix
    /${nixosModules}/services/tlp.nix
    /${nixosModules}/services/displayManager/ly.nix
  ];

  xserver = [
    /${nixosModules}/xserver/base.nix
    # (import /${nixosModules}/xserver/displayManager/lightdm.nix)
    (import /${nixosModules}/xserver/windowManager/i3wm.nix { inherit pkgs; })
  ];

  systemdUserServiceUnits = [
    /${nixosModules}/systemd/polkit-kde-agent.nix
    /${nixosModules}/systemd/ssh-agent.nix
  ];

  # Applications
  xremap = /${nixosModules}/applications/xremap.nix;
  fcitx5 = /${nixosModules}/applications/fcitx5.nix;
  tailscale = /${nixosModules}/applications/tailscale.nix;
  pipewire = /${nixosModules}/applications/pipewire.nix;
  thunar = /${nixosModules}/applications/thunar.nix;
  xss-i3lock = /${nixosModules}/applications/xss-i3lock.nix;
in
{
  imports = [
    hardware

    # configuration.nix top level keys
    nix
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

    # Applications
    xremap
    fcitx5
    tailscale
    pipewire
    thunar
    xss-i3lock
  ] ++ services ++ xserver ++ systemdUserServiceUnits;

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
