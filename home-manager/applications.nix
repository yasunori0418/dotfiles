{ pkgs, ... }:
{
  nixTools = with pkgs; [
    nix-prefetch-github
    nix-output-monitor
    nix-search-cli
    nix-direnv
  ];

  utilityTools = with pkgs; [
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
  ];

  languageServers = with pkgs; [
    nixd
    efm-langserver
    pyright
    bash-language-server
    intelephense
    phpactor
    typescript-language-server
    yaml-language-server
    emmet-ls
    vscode-langservers-extracted
    vtsls
    taplo
    jq-lsp
  ];

  codingSupportTools = with pkgs; [
    nixfmt-rfc-style
    statix
    shellcheck
    php83Packages.php-codesniffer
    php83Packages.phpmd
    php83Extensions.xdebug
    blade-formatter
    ruff
    beautysh
    sql-formatter
    eslint_d
    prettierd
    # biome # see https://nixpk.gs/pr-tracker.html?pr=384904
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
  ];

  clojureTools = with pkgs; [
    clojure
    clojure-lsp
    clj-kondo
    leiningen
    babashka
  ];
}
