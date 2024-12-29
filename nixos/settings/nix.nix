{
  nix = {
    checkConfig = true;
    settings = {
      auto-optimise-store = true;
      sandbox = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
