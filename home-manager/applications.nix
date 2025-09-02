{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  optional =
    env:
    let
      f = v: lib.optionals env v;
    in
    f;
  optionalIsLinux = optional pkgs.stdenv.isLinux;
  optionalIsDarwin = optional pkgs.stdenv.isDarwin;
  myNurPkgs = inputs.yasunori-nur.packages.${pkgs.system};
in
{
  nixTools = with pkgs; [
    nix-prefetch-github
    nix-output-monitor
    nix-search-cli
    nix-direnv
    cachix
  ];

  utilityTools = with pkgs; [
    gnumake
    git
    git-credential-manager
    git-lfs
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
    tree-sitter
    act
  ];

  textEditors = with pkgs; [
    myNurPkgs.neovim
    myNurPkgs.vim
    neovide
    emacs
  ];

  terminalEmulators =
    with pkgs;
    [
      kitty
      alacritty
    ]
    ++ (optionalIsLinux [ ghostty ])
    ++ (optionalIsDarwin [ ghostty-bin ]);

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

  aiTools = with pkgs; [
    codex
    # goose-cli
    myNurPkgs.claude-code
    myNurPkgs.ccusage
  ]
  # ++ (optionalIsLinux [ inputs.claude-desktop.packages.${system}.claude-desktop ])
  ;

  libraries = with pkgs; [
    gcc
    go
    bun
    volta
    rustup
    ruby
    nodejs_24
    pnpm
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

  guiTools = with pkgs; [
    google-chrome
    discord
    dbeaver-bin
    jetbrains-toolbox
  ];

  linuxDesktop = {
    theme = with pkgs; [
      themechanger
      libsForQt5.qt5ct
      libsForQt5.qtstyleplugins
      nordic
      nordzy-icon-theme
      nordzy-cursor-theme
    ];

    desktopApps = with pkgs; [
      gparted
      slack
      arandr
      blueberry
      pavucontrol
      gthumb
      peek
      simplescreenrecorder
      font-manager
      xfce.xfce4-screenshooter
      rofi
      rofi-power-menu
      feh
      picom
      dunst
      clipmenu
      ncpamixer
      xsel
    ];

    i3wmTools =
      let
        override-bumblebee-status = pkgs.bumblebee-status.override {
          plugins =
            p: with p; [
              title
              cpu2
              memory
              nic
              datetime
              battery
              dunstctl
              indicator
              error
            ];
        };
      in
      with pkgs;
      [
        i3status
        i3status-rust
        # override-bumblebee-status
      ];
  };

  macOs = with pkgs; [
    aerospace
  ];
}
