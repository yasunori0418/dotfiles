{ pkgs, ... }:
{
  nixTools = with pkgs; [
    nix-prefetch-github
    nix-output-monitor
    nix-search-cli
    nix-direnv
  ];

  utilityTools = with pkgs; [
    gnumake
    git
    jnv
    usql
    glow
    gh
    awscli2
    ssm-session-manager-plugin
    lemonade
    unzip
    direnv
    tmux
    zip
    typos
    lnav
    deno
  ];

  textEditors = with pkgs; [
    vim
    neovim
  ];

  terminalEmulators = with pkgs; [
    kitty
    alacritty
  ];

  shellTools = with pkgs; [
    sheldon
    bat
    dasel
    jq
    yq
    ripgrep
    ghq
    delta
    fd
    fzf
    eza
    yazi
    tdf
    rip2
  ];

  languageServers = with pkgs; [
    nixd
    efm-langserver
    pyright
    bash-language-server
    typescript-language-server
    yaml-language-server
    emmet-ls
    vscode-langservers-extracted
    vtsls
    taplo
    jq-lsp
    typos-lsp
    awk-language-server
    lua-language-server
  ];

  codingSupportTools = with pkgs; [
    nixfmt-rfc-style
    statix
    shellcheck
    blade-formatter
    ruff
    beautysh
    sql-formatter
    eslint_d
    prettierd
    biome
  ];

  aiTools = with pkgs; [
    codex
    goose-cli
  ];

  libraries = with pkgs; [
    gcc
    go
    bun
    volta
    rustup
    ruby
    ncurses
    luajitPackages.luarocks
    nodejs_22
    python312Packages.uv
    perl
  ];

  clojureTools = with pkgs; [
    clojure
    clojure-lsp
    clj-kondo
    leiningen
    babashka
  ];
}
