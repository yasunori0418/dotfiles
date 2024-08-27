{ pkgs, ... }:
let
  hardware = ./hardware-configuration.nix;

  # configuration.nix top level keys
  nix = import ../modules/nix.nix;
  boot = import ../modules/boot.nix;
  networking = import ../modules/networking.nix { hostName = "yasunori-laptop"; };
  environment = import ../modules/environment.nix;
  time = import ../modules/time.nix;
  i18n = import ../modules/i18n.nix;
  security = import ../modules/security.nix;
  programs = import ../modules/programs.nix;
  users = import ../modules/users.nix;
  fonts = import ../modules/fonts.nix;
  virtualisation = import ../modules/virtualisation.nix;
  qt = import ../modules/qt.nix;

  services = {
    printing = import ../modules/services/printing.nix;
    openssh = import ../modules/services/openssh.nix;
    tlp = import ../modules/services/tlp.nix;
  };

  xserver = {
    base = import ../modules/xserver/base.nix;
    lightdm = import ../modules/xserver/displayManager/lightdm.nix;
    i3wm = import ../modules/xserver/windowManager/i3wm.nix { inherit pkgs; };
  };

  systemdUserServiceUnits = {
    polkit-kde-agent = import ../modules/systemd/polkit-kde-agent.nix;
    ssh-agent = import ../modules/systemd/ssh-agent.nix;
  };

  # Applications
  xremap = import ../modules/applications/xremap.nix;
  fcitx5 = import ../modules/applications/fcitx5.nix;
  tailscale = import ../modules/applications/tailscale.nix;
  pipewire = import ../modules/applications/pipewire.nix;
  thunar = import ../modules/applications/thunar.nix;
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
    services.openssh
    services.printing
    services.tlp
    xserver.base
    xserver.lightdm
    xserver.i3wm
    systemdUserServiceUnits.polkit-kde-agent
    systemdUserServiceUnits.ssh-agent
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
  ];

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
