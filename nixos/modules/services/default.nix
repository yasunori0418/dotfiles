let
  openssh = import ./openssh.nix;
in {
  inherit openssh;
  # Enable CUPS to print documents.
  printing.enable = true;
}
