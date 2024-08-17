let
  openssh = import ./openssh.nix;
  xserver = import ./xserver;
in
{
  inherit openssh xserver;

  # Enable CUPS to print documents.
  printing.enable = true;
}
