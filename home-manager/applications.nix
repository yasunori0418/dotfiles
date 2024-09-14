{ pkgs, ... }:
{
  nixTools = with pkgs; [
    nix-prefetch-github
  ];

  utilityTools = with pkgs; [
    vim-startuptime
    tokei
    jnv
    hyperfine
    dasel
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
    efm-langserver
    lua-language-server
    stylua
    luajitPackages.luacheck
    pyright
    ruff
    bash-language-server
    shellcheck
    beautysh
    nodePackages.sql-formatter
    checkmake
    markdownlint-cli
    intelephense
    php83Packages.php-codesniffer
    php83Packages.phpmd
    php83Extensions.xdebug
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
