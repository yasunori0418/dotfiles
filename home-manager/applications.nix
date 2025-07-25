{
  inputs,
  pkgs,
  lib,
  nodePkgs,
  ...
}:
{
  nixTools = with pkgs; [
    nix-prefetch-github
    nix-output-monitor
    nix-search-cli
    nix-direnv
    node2nix
  ];

  utilityTools =
    with pkgs;
    [
      gnumake
      git
      git-credential-manager
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
      zellij
      zip
      typos
      lnav
      deno
      unar
      kanata-with-cmd
      colorized-logs
      asciinema
      asciinema-agg
      pueue
    ];

  textEditors =
    with pkgs;
    let
      vim-latest = vim.overrideAttrs (prev: {
        version = "latest";
        src = inputs.vim-src;
        configureFlags =
          prev.configureFlags
          ++ [
            "--enable-fail-if-missing"
            "--enable-autoservername"
            "--with-features=huge"

            # if_lua
            "--enable-luainterp"
            "--with-lua-prefix=${lua}"

            # if_python3
            "--enable-python3interp=yes"
            "--with-python3-command=${python3}/bin/python3"
            "--with-python3-config-dir=${python3}/lib"
            # Disable python2
            "--disable-pythoninterp"

            # if_ruby
            "--with-ruby-command=${ruby}/bin/ruby"
            "--enable-rubyinterp"

            # if_cscope
            "--enable-cscope"

            # clipboard
            "--enable-clipboard=yes"
            "--enable-multibyte"
          ]
          ++ (lib.optionals stdenv.isLinux [
            "--enable-gui=auto"
            "--enable-fontset"
            "--with-x"
            # お試しで有効にしたけど上手く有効化できてないシリーズ
            "--enable-xim"
            "--enable-xterm_save"
          ]);
        buildInputs =
          prev.buildInputs
          ++ [
            lua
            python3
            ruby
            libsodium
          ]
          ++ (lib.optionals stdenv.isLinux [
            xorg.libX11
            xorg.libXt
          ]);
      });
      # neovim-nightly = neovim-unwrapped.overrideAttrs {
      #   version = "v0.12.0-dev";
      #   src = inputs.neovim-src;
      # };
    in
    [
      vim-latest
      neovim
      neovide
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
    terraform-ls
    sqls
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

  aiTools =
    with pkgs;
    [
      codex
      # goose-cli
      nodePkgs."@anthropic-ai/claude-code"
      nodePkgs."ccusage"
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
