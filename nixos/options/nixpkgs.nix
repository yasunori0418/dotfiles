_: {
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ (import ../../nix-overlays/clipcat.nix) ];
  };
}
