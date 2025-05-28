{
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
      "aerospace"
      "dbeaver-community"
      "temurin@17"
      "jetbrains-toolbox"
      "rancher" # similar docker desktop
      "cursor"
      "discord"
      "as-timer"
      "obsidian"
      "claude"
      "raycast"
      "jordanbaird-ice"
      "meetingbar"
      "keycastr"
    ];
    brews = [
      "tailscale"
      "watch"
      "coreutils"
      "tfenv"
    ];
    taps = [
      "nikitabobko/tap" # for aerospace
    ];
  };

}
