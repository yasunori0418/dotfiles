{
  nixos-hardware,
  xremap-flake,
  ...
}:
let
  lenovoThinkpadE14Amd = nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd;
  hardware = ./hardware-configuration.nix;

  # configuration.nix top level keys
  nix = ../settings/nix.nix;
  nixpkgs = ../settings/nixpkgs.nix;
  system = ../settings/system.nix;
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

  systemdUserServiceUnits = [
    ../settings/systemd/polkit-kde-agent.nix
    ../settings/systemd/ssh-agent.nix
  ];

  # Applications
  xremapModule = xremap-flake.nixosModules.default;
  xremap = ../settings/applications/xremap.nix;
  fcitx5 = ../settings/applications/fcitx5.nix;
  tailscale = ../settings/applications/tailscale.nix;
  pipewire = ../settings/applications/pipewire.nix;
  thunar = ../settings/applications/thunar.nix;
  xss-i3lock = ../settings/applications/xss-i3lock.nix;
in
{
  imports =
    [
      lenovoThinkpadE14Amd
      hardware

      # configuration.nix top level keys
      nix
      nixpkgs
      system
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
      xremapModule
      xremap
      fcitx5
      tailscale
      pipewire
      thunar
      xss-i3lock
    ]
    ++ services
    ++ xserver
    ++ systemdUserServiceUnits;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
