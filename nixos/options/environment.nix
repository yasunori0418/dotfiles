{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      exfat
    ];
  };
}
