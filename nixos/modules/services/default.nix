{ pkgs }:
let
  openssh = import ./openssh.nix;
  xserver = import ./xserver { inherit pkgs; };
  tlp = import ./tlp.nix;
in {
  inherit openssh xserver tlp;

  # Enable CUPS to print documents.
  printing.enable = true;
}
