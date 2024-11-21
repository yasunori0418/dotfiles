# Generated by OrbStack.
# This WILL be overwritten in the future. Make a copy and update the include
# in configuration.nix if you want to keep your changes.

{ lib, config, ... }:

{
  # Add OrbStack CLI tools to PATH
  environment.shellInit =
    let
      macHomeDir = "/mnt/mac/Users/watanabe";
      nixHomeDir = config.users.users.yasunori.home;
    in
    ''
      . /opt/orbstack-guest/etc/profile-early

      # add your customizations here

      . /opt/orbstack-guest/etc/profile-late

      if [[ ! -L ${nixHomeDir}/dotfiles ]]; then
        rm -rf ${nixHomeDir}/dotfiles
      fi
      if [[ ! -L ${nixHomeDir}/src ]]; then
        rm -rf ${nixHomeDir}/src
      fi
      if [[ ! -L ${nixHomeDir}/.ssh ]]; then
        rm -rf ${nixHomeDir}/.ssh
      fi
      ln -svf ${macHomeDir}/dotfiles ${nixHomeDir}/
      ln -svf ${macHomeDir}/src ${nixHomeDir}/
      ln -svf ${macHomeDir}/.ssh ${nixHomeDir}/
    '';

  # Enable documentation
  documentation.man.enable = true;
  documentation.doc.enable = true;
  documentation.info.enable = true;

  # Disable systemd-resolved
  services.resolved.enable = false;
  environment.etc."resolv.conf".source = "/opt/orbstack-guest/etc/resolv.conf";

  # Faster DHCP - OrbStack uses SLAAC exclusively
  networking.dhcpcd.extraConfig = ''
    noarp
    noipv6
  '';

  # Disable sshd
  services.openssh.enable = false;

  # systemd
  systemd.services."systemd-oomd".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-userdbd".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-udevd".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-timesyncd".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-timedated".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-portabled".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-nspawn@".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-machined".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-localed".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-logind".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-journald@".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-journald".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-journal-remote".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-journal-upload".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-importd".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-hostnamed".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-homed".serviceConfig.WatchdogSec = 0;
  systemd.services."systemd-networkd".serviceConfig.WatchdogSec =
    lib.mkIf config.systemd.network.enable
      0;

  # ssh config
  programs.ssh.extraConfig = ''
    Include /opt/orbstack-guest/etc/ssh_config
  '';

  # indicate builder support for emulated architectures
  nix.settings.extra-platforms = [
    "x86_64-linux"
    "i686-linux"
  ];
}
