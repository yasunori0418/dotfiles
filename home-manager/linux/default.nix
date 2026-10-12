{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports =
    let
      packages = ./packages.nix;
      layat = import ./layat.nix {
        inherit
          inputs
          pkgs
          ;
      };
      clearDppStateAfterLinkGeneration = ../clear-dpp-state-after-link-generation.nix;
      linkHerdrPlugins = ../link-herdr-plugins.nix;
      registerClaudeMcpServers = ../register-claude-mcp-servers.nix;
      programs = [
        ../options/programs/nix-index.nix
        ../options/programs/discord.nix
      ];
      xdg = ../options/xdg.nix;
      nix = ../options/nix.nix;
      dconf = ../options/dconf.nix;
    in
    [
      packages
      layat
      clearDppStateAfterLinkGeneration
      linkHerdrPlugins
      registerClaudeMcpServers
      xdg
      nix
      dconf
    ]
    ++ programs;
  programs.home-manager.enable = true;
  home = {
    username = "yasunori";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "24.05";
    extraOutputsToInstall = [
      "doc"
      "info"
      "devdoc"
    ];
  };
}
