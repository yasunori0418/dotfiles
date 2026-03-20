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
      "stats"
      "temurin@17"
      "temurin@21"
      "rancher" # similar docker desktop
      "cursor"
      "as-timer"
      "obsidian"
      "claude"
      "raycast"
      "jordanbaird-ice"
      "meetingbar"
      "keycastr"
      "kotlin-lsp"
    ];
    brews = [
      "tailscale"
      "watch"
      "coreutils"
      "tfenv"
      "gh"
      "gh-asset"
    ];
    taps = [
      "YuitoSato/gh-asset"
    ];
  };

}
