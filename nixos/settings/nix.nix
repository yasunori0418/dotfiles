{ inputs, pkgs, ... }:
{
  nix = {
    checkConfig = true;
    package = inputs.nix-monitored.packages.${pkgs.system}.default.override { withNotify = false; };
    settings = {
      auto-optimise-store = true;
      sandbox = true;
      keep-outputs = true;
      keep-derivations = true;
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];

      trusted-substituters = [
        "https://hydra.nixos.org/"
        "https://nix-community.cachix.org"
        "https://yasunori0418.cachix.org"
      ];
      trusted-public-keys = [
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "yasunori0418.cachix.org-1:mC1j+M5A6063OHaOB5bH2nS0BiCW/BJsSRiOWjLeV9o="
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];

    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
