{ pkgs }:
let
  applicationList = import ../applications.nix { inherit pkgs; };
in
{
  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages =
      with pkgs;
      [
        i3status
        i3status-rust
        (bumblebee-status.override {
          plugins = p: [
            p.title
            p.cpu2
            p.memory
            p.nic
            p.datetime
            p.battery
            p.dunstctl
            p.indicator
            p.error
          ];
        })
      ]
      ++ applicationList.systemThemeTools
      ++ applicationList.nordThemePkgs
      ++ applicationList.desktopTools
      ++ applicationList.xfceTools
      ++ applicationList.otherTools;
  };
}
