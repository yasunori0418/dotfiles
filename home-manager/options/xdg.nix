{ pkgs, ... }:
{
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
    };
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        sway = {
          default = "gtk";
          "org.freedesktop.impl.portal.Inhibit" = "none";
          "org.freedesktop.impl.portal.ScreenCast" = "wlr";
          "org.freedesktop.impl.portal.Screenshot" = "wlr";
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };
  };
}
