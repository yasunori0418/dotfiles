{ nixpkgsOverlay, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (import "${nixpkgsOverlay}/libskk.nix")
    ];
  };
}
