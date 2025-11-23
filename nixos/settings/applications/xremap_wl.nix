# { pkgs, ... }:
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
        # {
        #   name = "emacs-like keybinds.";
        #   # https://github.com/xremap/xremap/blob/master/example/emacs.yml
        #   remap = {
        #     C-h = "backspace";
        #
        #     C-Shift-a = "C-Shift-a";
        #
        #     # Cursor
        #     C-f = {
        #       with_mark = "right";
        #     };
        #     C-b = {
        #       with_mark = "left";
        #     };
        #     C-p = {
        #       with_mark = "up";
        #     };
        #     C-n = {
        #       with_mark = "down";
        #     };
        #
        #     # Forward/Backward word
        #     M-f = {
        #       with_mark = "C-right";
        #     };
        #     M-b = {
        #       with_mark = "C-left";
        #     };
        #
        #     # Beginning/End of line
        #     C-a = {
        #       with_mark = "home";
        #     };
        #     C-e = {
        #       with_mark = "end";
        #     };
        #
        #     # Page up/down
        #     M-v = {
        #       with_mark = "pageup";
        #     };
        #     C-v = {
        #       with_mark = "pagedown";
        #     };
        #
        #     # Beginning/End of file
        #     M-Shift-comma = {
        #       with_mark = "C-home";
        #     };
        #     M-Shift-dot = {
        #       with_mark = "C-end";
        #     };
        #
        #     # newline
        #     C-m = "enter";
        #
        #     # Copy
        #     C-w = [
        #       "C-x"
        #       { set_mark = false; }
        #     ];
        #     M-w = [
        #       "C-c"
        #       { set_mark = false; }
        #     ];
        #     C-y = [
        #       "C-v"
        #       { set_mark = false; }
        #     ];
        #
        #     # Delete
        #     C-d = [
        #       "delete"
        #       { set_mark = false; }
        #     ];
        #     M-d = [
        #       "C-delete"
        #       { set_mark = false; }
        #     ];
        #
        #     # Kill line
        #     C-k = [
        #       "Shift-end"
        #       "C-x"
        #       { set_mark = false; }
        #     ];
        #
        #     # Kill word backward
        #     Alt-backspace = [
        #       "C-backspace"
        #       { set_mark = false; }
        #     ];
        #
        #     # set mark next word continuously.
        #     C-M-space = [
        #       "C-Shift-right"
        #       { set_mark = true; }
        #     ];
        #
        #     # Undo
        #     C-slash = [
        #       "C-z"
        #       { set_mark = false; }
        #     ];
        #
        #     # Mark
        #     C-space = {
        #       set_mark = true;
        #     };
        #
        #     # Search
        #     C-s = "C-f";
        #     C-r = "Shift-F3";
        #     M-Shift-5 = "C-h";
        #
        #     # Cancel
        #     C-g = [
        #       "esc"
        #       { set_mark = false; }
        #     ];
        #
        #     # C-x YYY
        #     C-x = {
        #       remap = {
        #         # C-x h (select all)
        #         C-h = [
        #           "C-home"
        #           "C-a"
        #           { set_mark = true; }
        #         ];
        #
        #         # C-x C-f (open)
        #         C-f = "C-o";
        #
        #         # C-x C-s (save)
        #         C-s = "C-s";
        #
        #         # C-x k (kill tab)
        #         C-k = "C-F4";
        #
        #         # C-x C-c (exit)
        #         C-c = "Super-Shift-q";
        #
        #         # C-x u (undo)
        #         C-u = [
        #           "C-z"
        #           { set_mark = false; }
        #         ];
        #
        #       };
        #     };
        #   };
        #   application = {
        #     not = [
        #       "/wezterm/"
        #       "/kitty/"
        #       "/Alacritty/"
        #       "/ghostty/"
        #       "/Emacs/"
        #       "/neovide/"
        #     ];
        #   };
        #   device = {
        #     not = [ ];
        #   };
        # }
      ];
    };
  };
}
