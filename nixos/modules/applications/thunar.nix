# Refer: https://nixos.wiki/wiki/Thunar
{ pkgs, ... }:
{
  programs = {
    # If xfce is not used as desktop and therefore xfconf is not enabled,
    # preference changes are discarded.
    # In that case enable the xfconf program manually to be able to save preference
    xfconf.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
        thunar-media-tags-plugin
      ];
    };
  };
  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
  };
}
