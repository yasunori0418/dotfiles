{ pkgs, ... }:
{
  nix = {
    checkConfig = true;
    nixPath = [
      "nixpkgs=flake:nixpkgs"
    ];
    # settings = {
    #   experimental-features = "nix-command flakes pipe-operators";
    #   max-jobs = 8;
    #   # sandbox = "relaxed";
    #   substituters = [
    #     "https://nix-community.cachix.org"
    #     "https://yasunori0418.cachix.org"
    #     "https://devenv.cachix.org"
    #     "https://cache.numtide.com"
    #   ];
    #   trusted-substituters = [
    #     "https://nix-community.cachix.org"
    #     "https://yasunori0418.cachix.org"
    #     "https://devenv.cachix.org"
    #     "https://cache.numtide.com"
    #   ];
    #   trusted-public-keys = [
    #     "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    #     "yasunori0418.cachix.org-1:mC1j+M5A6063OHaOB5bH2nS0BiCW/BJsSRiOWjLeV9o="
    #     "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    #     "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    #   ];
    # };
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
