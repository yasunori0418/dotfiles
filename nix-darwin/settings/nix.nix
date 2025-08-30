{ inputs, pkgs, ... }:
{
  nix = {
    enable = true;
    optimise.automatic = true;
    package = inputs.nix-monitored.packages.${pkgs.system}.default;
    settings = {
      experimental-features = "nix-command flakes pipe-operators";
      max-jobs = 8;
      sandbox = "relaxed";
      substituters = [
        "https://nix-community.cachix.org"
        "https://yasunori0418.cachix.org"
      ];
      trusted-substituters = [
        "https://nix-community.cachix.org"
        "https://yasunori0418.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "yasunori0418.cachix.org-1:mC1j+M5A6063OHaOB5bH2nS0BiCW/BJsSRiOWjLeV9o="
      ];
    };
  };
}
