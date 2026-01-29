{ pkgs, ... }:
{
  nix = {
    checkConfig = true;
    nixPath = [
      "nixpkgs=flake:nixpkgs"
    ];
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      max-jobs = 8;
      sandbox = if pkgs.stdenv.isLinux then true else "relaxed";
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://yasunori0418.cachix.org"
        "https://devenv.cachix.org"
        "https://cache.numtide.com"
        "https://ryoppippi.cachix.org"
      ];
      trusted-substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://yasunori0418.cachix.org"
        "https://devenv.cachix.org"
        "https://cache.numtide.com"
        "https://ryoppippi.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "yasunori0418.cachix.org-1:mC1j+M5A6063OHaOB5bH2nS0BiCW/BJsSRiOWjLeV9o="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        "ryoppippi.cachix.org-1:b2LbtWNvJeL/qb1B6TYOMK+apaCps4SCbzlPRfSQIms="
      ];
    };
    registry = {
      nixpkgs = {
        from = {
          id = "nixpkgs";
          type = "indirect";
        };
        to = {
          type = "path";
          path = "${builtins.toString pkgs.path}";
        };
      };
    };
  };
}
