{ pkgs, ... }:
{
  # nix自体の設定
  nix = {
    enable = true;
    optimise.automatic = true;
    settings = {
      experimental-features = "nix-command flakes pipe-operators";
      max-jobs = 8;
      sandbox = "relaxed";
    };
  };

  # homebrew
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall"; # nix-darwin経由だけでbrew installさせる
    };
    casks = [
      "1password"
      "1password-cli"
      "ghostty"
      "kitty"
      "stats"
      "nikitabobko/tap/aerospace"
      "dbeaver-community"
      "docker"
      "temurin@17"
      "jetbrains-toolbox"
    ];
    brews = [
      "docker-compose"
      "watch"
    ];
  };

  # フォントの設定
  fonts = {
    packages = with pkgs; [
      hackgen-nf-font
    ];
  };

  # システムの設定（nix-darwinが効いているかのテスト）
  system = {
    stateVersion = 6;
    defaults = {
      NSGlobalDomain.AppleShowAllExtensions = true;
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
