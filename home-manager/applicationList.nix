{ pkgs, ... }:
{
  nixTools = with pkgs; [
    nix-prefetch-github
  ];

  utilityTools = with pkgs; [
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
