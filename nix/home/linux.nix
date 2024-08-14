{ ... }: {
  imports = [
    ./pkgs.nix
  ];
  programs.home-manager.enable = true;
  home = rec {
    username = "yasunori";
    homeDirectory = "/home/${username}";
    stateVersion = "22.11";
  };
}
