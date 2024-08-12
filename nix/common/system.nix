{ ... }: {
  nix = {
    checkConfig = true;
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-then 7d";
    };
  };
  nixpkgs.config.allowUnfree = true;
}
