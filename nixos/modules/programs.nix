{ pkgs, ... }:
{
  ssh.startAgent = true;
  zsh.enable = true;
  nix-ld = {
    enable = true;
    # libraries = with pkgs; [];
  };
}
