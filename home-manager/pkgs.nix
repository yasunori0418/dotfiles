{
  pkgs,
  lib,
  wezterm-flake,
  ...
}:
{
  home.packages = with pkgs; [
    (lib.mkIf pkgs.stdenv.isLinux kitty)
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
    (lib.mkIf pkgs.stdenv.isLinux wezterm-flake.packages.${pkgs.system}.default)
  ];
}
