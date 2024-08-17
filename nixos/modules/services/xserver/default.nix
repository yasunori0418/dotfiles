let
  lightdm = import ./displayManager/lightdm.nix;
  i3 = import ./windowManager/i3wm.nix;
in
{
  # Enable the X11 windowing system.
  enable = true;

  # Configure keymap in X11
  xkb.layout = "us";

  displayManager = {
    inherit lightdm;
  };

  windowManager = {
    inherit i3;
  };

}
