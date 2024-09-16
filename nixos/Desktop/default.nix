{
  nixos-hardware,
  nixosSettings,
  xremap-flake,
  ...
}:
let
  hardwareModules = with nixos-hardware.nixosModules; [
    common-cpu-amd-zenpower
    common-gpu-nvidia-sync
    common-pc-ssd
  ];
  hardware = ./hardware-configuration.nix;
  extraMountFilesystems = ./extra-mount-filesystems.nix;
  nvidia = /${nixosSettings}/nvidia.nix;

  # configuration.nix top level keys
  nix = /${nixosSettings}/nix.nix;
  boot = /${nixosSettings}/boot.nix;
  networking = import /${nixosSettings}/networking.nix { hostName = "yasunori-desktop"; };
  environment = /${nixosSettings}/environment.nix;
  time = /${nixosSettings}/time.nix;
  i18n = /${nixosSettings}/i18n.nix;
  security = /${nixosSettings}/security.nix;
  programs = /${nixosSettings}/programs.nix;
  users = /${nixosSettings}/users.nix;
  fonts = /${nixosSettings}/fonts.nix;
  virtualisation = /${nixosSettings}/virtualisation.nix;
  qt = /${nixosSettings}/qt.nix;

  services = [
    /${nixosSettings}/services/printing.nix
    /${nixosSettings}/services/openssh.nix
    /${nixosSettings}/services/tlp.nix
    /${nixosSettings}/services/displayManager/ly.nix
  ];

  xserver = [
    /${nixosSettings}/xserver/base.nix
    # (import /${nixosSettings}/xserver/displayManager/lightdm.nix { greeterName = "mini"; })
    /${nixosSettings}/xserver/windowManager/i3wm.nix
  ];

  systemdUserServiceUnits = [
    /${nixosSettings}/systemd/polkit-kde-agent.nix
    /${nixosSettings}/systemd/ssh-agent.nix
  ];

  # Applications
  xremapModule = xremap-flake.nixosModules.default;
  xremap = /${nixosSettings}/applications/xremap.nix;
  fcitx5 = /${nixosSettings}/applications/fcitx5.nix;
  tailscale = /${nixosSettings}/applications/tailscale.nix;
  pipewire = /${nixosSettings}/applications/pipewire.nix;
  thunar = /${nixosSettings}/applications/thunar.nix;
  xss-i3lock = /${nixosSettings}/applications/xss-i3lock.nix;
in
{

  imports = [
    hardware
    extraMountFilesystems
    nvidia

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
    xremapModule
    xremap
    fcitx5
    tailscale
    pipewire
    thunar
    xss-i3lock
  ] ++ services ++ xserver ++ systemdUserServiceUnits ++ hardwareModules;

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
