{ pkgs, ... }:
{
  services.xserver.displayManager.lightdm.greeters.gtk = {
    enable = true;
    theme = {
      name = "Nordic-darker";
      package = pkgs.nordic;
    };
    cursorTheme = {
      name = "Nordzy-cursors";
      package = pkgs.nordzy-cursor-theme;
    };
    iconTheme = {
      name = "Nordzy";
      package = pkgs.nordzy-icon-theme;
    };
    indicators = [
      "~host"
      "~spacer"
      "~clock"
      "~spacer"
      "~session"
      "~language"
      "~a11y"
      "~power"
    ];
    clock-format = "%Y/%m/%d %H:%M:%S";
  };
}
