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
      clearDppStateAfterLinkGeneration = ../clear-dpp-state-after-link-generation.nix;
      linkHerdrPlugins = ../link-herdr-plugins.nix;
      injectClaudeSettings = ../inject-claude-settings.nix;
      launchd = [
        # ../options/launchd/clipcatd.nix
      ];
      programs = [
        ../options/programs/nix-index.nix
        ../options/programs/discord.nix
      ];
      nput = import ./nput.nix {
        inherit
          inputs
          pkgs
          ;
        inherit (config.home) homeDirectory;
      };
    in
    [
      packages
      clearDppStateAfterLinkGeneration
      linkHerdrPlugins
      injectClaudeSettings
      inputs.mac-app-util.homeManagerModules.default
      nput
    ]
    ++ launchd
    ++ programs;
  programs.home-manager.enable = true;
  home = {
    username = "taiki.watanabe";
    homeDirectory = "/Users/${config.home.username}";
    stateVersion = "24.05";
    extraOutputsToInstall = [
      "doc"
      "info"
      "devdoc"
    ];
  };
}
