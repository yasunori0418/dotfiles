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
      time = ../settings/time.nix;
      networking = import ../settings/networking.nix {
        inherit hostName name;
      };
      system = import ../settings/system.nix {inherit name;};
    in
    [
      nix
      nixpkgs
      users
      homebrew
      fonts
      time
      networking
      system
    ];
}
