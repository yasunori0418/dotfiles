{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
{

  # # Run a single one-shot service that allows root's services to access user's X session
  # systemd.user.services.set-xhost = {
  #   description = "Run a one-shot command upon user login";
  #   path = [ pkgs.xorg.xhost ];
  #   wantedBy = [ "default.target" ];
  #   script = "xhost +SI:localuser:root";
  #   environment.DISPLAY = ":0.0"; # NOTE: This is hardcoded for this flake
  # };

  services.xremap =
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      package = inputs.yasunori-nur.packages.${system}.xremap-wlroots;
    in
    {
      inherit package;
      enable = true;
      withWlroots = true;
      watch = true;
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

              C-M-f = "C-f";

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

  # services.xremap が生成する WantedBy=graphical-session.target は
  # nixos-fake-graphical-session.target 経由で sway の起動完了前に発火するため、
  # WAYLAND_DISPLAY を持たないまま起動して wlroots への接続に失敗する
  # (journal に "Could not find wayland compositor" が出る)。
  # sway が import-environment 後に起動する sway-session.target へ紐付ける。
  systemd.user.services.xremap = {
    wantedBy = lib.mkForce [ "sway-session.target" ];
    after = [ "sway-session.target" ];
  };
}
