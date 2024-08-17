let
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
  virtualization = import ../modules/virtualization.nix;
  qt = import ../modules/qt.nix;
in
{
  inherit
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
    virtualization
    qt
  ;

  imports = [
    ./hardware-configuration.nix
    ../modules/applications/xremap.nix
    ../modules/applications/fcitx5.nix
    ../modules/applications/tailscale.nix
    ../modules/applications/pipewire.nix
    ../modules/systemd/polkit-kde-agent.nix
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
