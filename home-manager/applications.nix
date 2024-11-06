{ pkgs, ... }:
{
  nixTools = with pkgs; [
    nix-prefetch-github
    nix-search-cli
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
    hugo
    zellij
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
    efm-langserver
    lua-language-server
    pyright
    bash-language-server
    intelephense
    typescript-language-server
  ];

  codingSupportTools = with pkgs; [
    markdownlint-cli
    checkmake
    shellcheck
    php83Packages.php-codesniffer
    php83Packages.phpmd
    luajitPackages.luacheck
    ruff
    stylua
    beautysh
    nodePackages.sql-formatter
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
    python312Packages.uv
    pdm
  ];

  clojureTools = with pkgs; [
    clojure
    clojure-lsp
    clj-kondo
    leiningen
    babashka
  ];
}
