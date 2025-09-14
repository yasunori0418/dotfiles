{ pkgs, ... }:
{
  nix = {
    checkConfig = true;
    gc = {
      automatic = true;
      dates = "weekly";
      persistent = true;
      randomizedDelaySec = "0";
    };
    nixPath = [
      "nixpkgs=flake:nixpkgs"
    ];
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
