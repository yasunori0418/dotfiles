{ pkgs, ... }:
{
  hardware.sane = {
    enable = true;
    # TODO(2024-12-27): 修正されているけどnixpkgs-unstableに振ってこない
    # refer: https://nixpk.gs/pr-tracker.html?pr=365687
    # extraBackends = with pkgs; [
    #   epsonscan2
    # ];
    openFirewall = true;
  };
  environment.systemPackages = with pkgs; [
    simple-scan
  ];
}
