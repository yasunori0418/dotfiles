{
  modulesPath,
  xremap-flake,
  ...
}:
{
  imports =
    let
      # generated settings by orbstack.
      defaultSettings = [
        "${modulesPath}/virtualisation/lxc-container.nix" # Include the default lxd configuration.
        ./orbstack.nix # Include the OrbStack-specific configuration.
        ./users.nix
        ./networking.nix
      ];

      nix = ../settings/nix.nix;
      nixpkgs = import ../settings/nixpkgs.nix;
      system = ../settings/system.nix;
      hostToLocalSymlink = ./hostToLocalSymlink.nix;
      environment = ../settings/environment.nix;
      time = ../settings/time.nix;
      i18n = ../settings/i18n.nix;
      security = ../settings/security.nix;
      programs = ../settings/programs.nix;
      fonts = ../settings/fonts.nix;
      qt = ../settings/qt.nix;

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
      pipewire = ../settings/applications/pipewire.nix;
      thunar = ../settings/applications/thunar.nix;
      xss-i3lock = ../settings/applications/xss-i3lock.nix;
    in
    [
      nix
      nixpkgs
      system
      hostToLocalSymlink
      environment
      time
      i18n
      security
      programs
      fonts
      qt

      xremapModule
      xremap
      fcitx5
      pipewire
      thunar
      xss-i3lock
    ]
    ++ defaultSettings
    ++ xserver
    ++ systemdUserServiceUnits;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
