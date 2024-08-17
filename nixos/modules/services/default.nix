{ pkgs }:
let
  openssh = import ./openssh.nix;
  xserver = import ./xserver { inherit pkgs; };
in
{
  inherit openssh xserver;

  # Enable CUPS to print documents.
  printing.enable = true;
}
