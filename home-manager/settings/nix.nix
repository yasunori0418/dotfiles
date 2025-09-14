{ pkgs, ... }:
{
  nix = {
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
