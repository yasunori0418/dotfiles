{
  pkgs,
  lib,
  wezterm-flake,
  ...
}:
{
  home.packages = with pkgs; [
    kitty
    alacritty
    lemonade
    gcc
    ncurses
    unzip
    rustup
    luajitPackages.luarocks
    neovim
    vim
    emacs

    # aqua config.yaml
    sheldon
    bat
    gh
    jq
    ripgrep
    ghq
    delta
    (lib.mkIf pkgs.stdenv.isLinux deno) # 全部intel macって奴が悪いんだ！
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
    (lib.mkIf pkgs.stdenv.isDarwin wezterm)
    (lib.mkIf pkgs.stdenv.isLinux wezterm-flake.packages.${pkgs.system}.default)
  ];
}
