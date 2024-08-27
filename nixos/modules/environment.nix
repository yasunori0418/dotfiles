{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      vim
      exfat
      git
      gnumake
    ];
  };
}
