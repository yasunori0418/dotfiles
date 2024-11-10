{ pkgs, ... }:
{
  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [
      epsonscan2
    ];
    openFirewall = true;
  };
  environment.systemPackages = with pkgs; [
    simple-scan
  ];
}
