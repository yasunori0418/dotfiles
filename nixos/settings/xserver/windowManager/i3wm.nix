{ pkgs }:
{
  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages =
      let
        applications = import ../applications.nix { inherit pkgs; };
        extraPackages =
          with applications;
          [ ] ++ systemThemeTools ++ nordThemePkgs ++ desktopTools ++ xfceTools ++ otherTools;
      in
      with pkgs;
      [
        i3status
        i3status-rust
        (bumblebee-status.override {
          plugins =
            p: with p; [
              title
              cpu2
              memory
              nic
              datetime
              battery
              dunstctl
              indicator
              error
            ];
        })
      ]
      ++ extraPackages;
  };
}
