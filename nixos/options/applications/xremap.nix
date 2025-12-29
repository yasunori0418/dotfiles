{ config, ... }:
{

  # # Run a single one-shot service that allows root's services to access user's X session
  # systemd.user.services.set-xhost = {
  #   description = "Run a one-shot command upon user login";
  #   path = [ pkgs.xorg.xhost ];
  #   wantedBy = [ "default.target" ];
  #   script = "xhost +SI:localuser:root";
  #   environment.DISPLAY = ":0.0"; # NOTE: This is hardcoded for this flake
  # };

  services.xremap = {
    enable = true;
    withWlroots = true;
    serviceMode = "user";
    userName = config.users.users.yasunori.name;
    userId = config.users.users.yasunori.uid;
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
          name = "Ctrl-h backspace";
          remap = {
            C-h = "backspace";
          };
        }
        {
          name = "emacs-like keybinds.";
          # https://github.com/xremap/xremap/blob/master/example/emacs.yml
          remap = {
            C-h = "backspace";

            C-Shift-a = "C-Shift-a";

            # Cursor
            C-f = "right";
            C-b = "left";
            C-p = "up";
            C-n = "down";

            # Forward/Backward word
            M-f = "C-right";
            M-b = "C-left";

            # Beginning/End of line
            C-a = "home";
            C-e = "end";

            # newline
            C-m = "enter";

            # Delete
            C-d = "delete";

          };
          application = {
            not = [
              "com.mitchellh.ghostty"
              "Alacritty"
              "org.wezfurlong.wezterm"
              "kitty"
              "neovide"
              "/Emacs/"
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
