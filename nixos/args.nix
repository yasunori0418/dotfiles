inputs: {
  args =
    { profileName, system }:
    import ./default.nix {
      inherit inputs profileName system;
    };
}
