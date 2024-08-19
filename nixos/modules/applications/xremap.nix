{ pkgs, ... }:
{
  # Run a single one-shot service that allows root's services to access user's X session
  systemd.user.services.set-xhost = {
    description = "Run a one-shot command upon user login";
    path = [ pkgs.xorg.xhost ];
    wantedBy = [ "default.target" ];
    script = "xhost +SI:localuser:root";
    environment.DISPLAY = ":0.0"; # NOTE: This is hardcoded for this flake
  };

  services.xremap = {
    withX11 = true;
    config = {
      modmap = [
        {
          name = "Swapping Capslock and Ctrl_L";
          remap = {
            Capslock = "Ctrl_L";
            Ctrl_L = "Capslock";
          };
          device = {
            not = [ "HHKB" ];
          };
        }
      ];
      keymap = [
        {
          name = "Slightly emacs-like keymap.";
          remap = {
            C-h = "Backspace";
            C-a = "home";
            C-e = "end";
            C-f = "right";
            C-b = "left";
            C-p = "up";
            C-n = "down";
            C-m = "enter";
          };
          application = {
            not = [
              "/wezterm/"
              "/kitty/"
              "/alacritty/"
            ];
          };
          device = {
            not = [ ];
          };
        }
      ];
    };
  };
}
