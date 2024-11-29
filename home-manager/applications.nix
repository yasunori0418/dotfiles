{ pkgs, ... }:
{
  nixTools = with pkgs; [
    nix-prefetch-github
    nix-search-cli
    devenv
    nix-direnv
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
    direnv
    tmux
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
    yaml-language-server
    emmet-ls
    vscode-langservers-extracted
    vtsls
  ];

  codingSupportTools = with pkgs; [
    nixfmt-rfc-style
    markdownlint-cli
    checkmake
    shellcheck
    php83Packages.php-codesniffer
    php83Packages.phpmd
    php83Extensions.xdebug
    blade-formatter
    luajitPackages.luacheck
    ruff
    stylua
    beautysh
    nodePackages.sql-formatter
    eslint_d
    prettierd
    biome
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
