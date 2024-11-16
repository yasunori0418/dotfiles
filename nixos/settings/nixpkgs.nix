{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (import ../../nix-overlays/libskk.nix)
    ];
  };
}
