{ name, ... }:
{
  system = {
    stateVersion = 6;
    primaryUser = name;
    activationScripts.postActivation.text = ''
      # Following line should allow us to avoid a logout/login cycle when changing settings
      # https://github.com/nix-darwin/nix-darwin/issues/518#issuecomment-2906740167
      sudo -u ${name} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        "com.apple.keyboard.fnState" = false;
        "com.apple.sound.beep.volume" = 0.0;
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
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
      # カスタムキーボードショートカット設定
      # @ = Command (⌘), $ = Shift (⇧), ~ = Option (⌥), ^ = Control (⌃)
      CustomUserPreferences = {
        # NSGlobalDomain = {
        #   NSUserKeyEquivalents = {
        #     # 全アプリケーション共通のショートカット例
        #     "Paste and Match Style" = "@$v"; # Cmd+Shift+V
        #     # "Minimize" = "@m";               # Cmd+M
        #     # "Close" = "@w";                  # Cmd+W
        #   };
        # };
        # 特定アプリケーション用のショートカット例
        # "com.apple.Safari" = {
        #   NSUserKeyEquivalents = {
        #     "Show All History" = "@$h";     # Cmd+Shift+H
        #   };
        # };

        # Symbolic Hotkeys設定
        # Spotlightを無効化し、入力ソース切り替えをCmd+Spaceに設定
        "com.apple.symbolichotkeys" = {
          AppleSymbolicHotKeys = {
            # Spotlight検索を無効化
            "64" = {
              enabled = false;
            };
            # Finder検索を無効化
            "65" = {
              enabled = false;
            };
            # 入力ソース切り替えをCmd+Spaceに設定
            "60" = {
              enabled = true;
              value = {
                type = "standard";
                parameters = [
                  32
                  49
                  1048576
                ];
              };
            };
            # 次の入力ソースを無効化
            "61" = {
              enabled = false;
            };
          };
        };
      };
    };
  };
}
