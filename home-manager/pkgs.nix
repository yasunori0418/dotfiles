{ pkgs, wezterm-flake, ... }:
{
  home.packages =
    with pkgs;
    [
      kitty
      alacritty
      lemonade
      gcc
      ncurses
      unzip
      rustup
      luajitPackages.luarocks

      # aqua config.yaml
      sheldon
      bat
      gh
      jq
      ripgrep
      ghq
      delta
      deno
      fd
      fzf
      eza
      go
      bun
      usql
      glow
      volta
      awscli2
      nix-prefetch-github
      nixd
    ]
    ++ [ wezterm-flake.packages.${pkgs.system}.default ];
}
