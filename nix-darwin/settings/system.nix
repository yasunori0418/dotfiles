{ name, ... }:
{
  system = {
    stateVersion = 6;
    primaryUser = name;
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        "com.apple.keyboard.fnState" = false;
        "com.apple.sound.beep.volume" = 0.0;
        KeyRepeat = 1;
        InitialKeyRepeat = 10;
      };
      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
      };
      dock = {
        autohide = true;
        show-recents = false;
        orientation = "left";
      };
    };
  };
}
