{ inputs, pkgs, ... }:
{
  nix = {
    checkConfig = true;
    package = inputs.nix-monitored.packages.${pkgs.system}.default;
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
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
