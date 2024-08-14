{ ... }: {
  home = rec {
    username = "yasunori";
    homeDirectory = "/home/${username}";
    stateVersion = "22.11";
  };
  programs.home-manager.enable = true;
}
