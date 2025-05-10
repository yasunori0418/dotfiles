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
    };
  };
}
