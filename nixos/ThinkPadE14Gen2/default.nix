{ pkgs, ... }:
let
  hardware = ./hardware-configuration.nix;

  # configuration.nix top level keys
  nix = ../modules/nix.nix;
  boot = ../modules/boot.nix;
  networking = import ../modules/networking.nix { hostName = "yasunori-laptop"; };
  environment = ../modules/environment.nix;
  time = ../modules/time.nix;
  i18n = ../modules/i18n.nix;
  security = ../modules/security.nix;
  programs = ../modules/programs.nix;
  users = ../modules/users.nix;
  fonts = ../modules/fonts.nix;
  virtualisation = ../modules/virtualisation.nix;
  qt = ../modules/qt.nix;

  services = [
    ../modules/services/printing.nix
    ../modules/services/openssh.nix
    ../modules/services/tlp.nix
    ../modules/services/displayManager/ly.nix
  ];

  xserver = [
    ../modules/xserver/base.nix
    # (import ../modules/xserver/displayManager/lightdm.nix)
    (import ../modules/xserver/windowManager/i3wm.nix { inherit pkgs; })
  ];

  systemdUserServiceUnits = [
    ../modules/systemd/polkit-kde-agent.nix
    ../modules/systemd/ssh-agent.nix
  ];

  # Applications
  xremap = ../modules/applications/xremap.nix;
  fcitx5 = ../modules/applications/fcitx5.nix;
  tailscale = ../modules/applications/tailscale.nix;
  pipewire = ../modules/applications/pipewire.nix;
  thunar = ../modules/applications/thunar.nix;
  xss-i3lock = ../modules/applications/xss-i3lock.nix;
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
