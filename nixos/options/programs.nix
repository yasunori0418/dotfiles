{
  programs = {
    zsh.enable = true;
    nix-ld = {
      enable = true;
      # libraries = with pkgs; [];
    };
    light = {
      enable = true;
      brightnessKeys.enable = true;
    };
  };
}
