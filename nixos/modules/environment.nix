{ pkgs, ... }:
{
  systemPackages = with pkgs; [
    vim
    exfat
    git
    gnumake
  ];
}
