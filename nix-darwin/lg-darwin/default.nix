{ pkgs, ... }:
{
  imports =
    let
      name = "taiki.watanabe";
      hostName = "LGPM-0151";

      nix = ../settings/nix.nix;
      nixpkgs = ../settings/nixpkgs.nix;
      users = import ../settings/users.nix {
        inherit pkgs name;
      };
      homebrew = ../settings/homebrew.nix;
      fonts = ../settings/fonts.nix;
      networking = import ../settings/networking.nix {
        inherit hostName name;
      };
      system = ../settings/system.nix;
    in
    [
      nix
      nixpkgs
      users
      homebrew
      fonts
      networking
      system
    ];
}
