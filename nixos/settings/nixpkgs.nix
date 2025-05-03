{ inputs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = import ../../nix-overlays inputs;
  };
}
