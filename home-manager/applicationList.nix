{
  pkgs,
  lib,
  wezterm-flake,
  ...
}:
{
  nixTools = with pkgs; [
    nix-prefetch-github
  ];

  utilityTools = with pkgs; [
    (lib.mkIf pkgs.stdenv.isLinux deno) # 全部intel macって奴が悪いんだ！
    usql
    glow
    gh
    awscli2
    lemonade
    unzip
  ];

  textEditors = with pkgs; [
    vim
    neovim
    emacs
  ];

  terminalEmulators = with pkgs; [
    kitty
    alacritty
    (if pkgs.stdenv.isLinux then wezterm-flake.packages.${pkgs.system}.default else wezterm)
  ];

  shellTools = with pkgs; [
    sheldon
    bat
    jq
    ripgrep
    ghq
    delta
    fd
    fzf
    eza
  ];

  languageServers = with pkgs; [
    nixd
    nil
  ];

  libraries = with pkgs; [
    gcc
    go
    bun
    volta
    rustup
    ncurses
    luajitPackages.luarocks
  ];
}
