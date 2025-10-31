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
    # keep-sorted start
    cachix
    nix-direnv
    nix-output-monitor
    nix-prefetch-github
    nix-search-cli
    # keep-sorted end
  ];

  utilityTools = with pkgs; [
    # keep-sorted start
    act
    asciinema
    asciinema-agg
    awscli2
    colorized-logs
    deno
    direnv
    gh
    git
    git-credential-manager
    git-lfs
    glow
    gnumake
    jnv
    kanata-with-cmd
    lemonade
    lnav
    myNurPkgs.safe-chain
    pueue
    ssm-session-manager-plugin
    tmux
    tree-sitter
    typos
    unar
    unzip
    usql
    zellij
    zip
    # keep-sorted end
  ];

  textEditors = with pkgs; [
    # keep-sorted start
    emacs
    myNurPkgs.neovim
    myNurPkgs.vim
    neovide
    neovim-remote
    # keep-sorted end
  ];

  terminalEmulators =
    with pkgs;
    [
      # keep-sorted start
      alacritty
      kitty
      # keep-sorted end
    ]
    ++ (optionalIsLinux [ ghostty ])
    ++ (optionalIsDarwin [ ghostty-bin ]);

  shellTools = with pkgs; [
    # keep-sorted start
    bat
    dasel
    delta
    eza
    fd
    fzf
    ghq
    jq
    myNurPkgs.gwq
    rip2
    ripgrep
    sheldon
    tdf
    yazi
    yq
    # keep-sorted end
  ];

  languageServers = with pkgs; [
    # keep-sorted start
    awk-language-server
    bash-language-server
    efm-langserver
    emmet-ls
    jq-lsp
    nixd
    pyright
    sqls
    taplo
    terraform-ls
    typescript-language-server
    typos-lsp
    vscode-langservers-extracted
    vtsls
    yaml-language-server
    # keep-sorted end
  ];

  codingSupportTools = with pkgs; [
    # keep-sorted start
    beautysh
    biome
    blade-formatter
    eslint_d
    nixfmt-rfc-style
    prettierd
    ruff
    shellcheck
    sql-formatter
    statix
    # actionlint
    # keep-sorted end
  ];

  aiTools = with pkgs; [
    # keep-sorted start
    codex
    myNurPkgs.cc-sdd
    myNurPkgs.ccexp
    myNurPkgs.cchook
    myNurPkgs.ccusage
    # goose-cli
    myNurPkgs.claude-code
    # keep-sorted end
  ]
  # ++ (optionalIsLinux [ inputs.claude-desktop.packages.${system}.claude-desktop ])
  ;

  libraries = with pkgs; [
    # keep-sorted start
    bun
    gcc
    go
    nodejs_24
    perl
    pnpm
    python312Packages.uv
    ruby
    rustup
    volta
    # keep-sorted end
  ];

  clojureTools = with pkgs; [
    # keep-sorted start
    babashka
    clj-kondo
    clojure
    clojure-lsp
    leiningen
    # keep-sorted end
  ];

  guiTools = with pkgs; [
    # keep-sorted start
    dbeaver-bin
    discord
    google-chrome
    jetbrains-toolbox
    # keep-sorted end
  ];

  linuxDesktop = {
    theme = with pkgs; [
      # keep-sorted start
      libsForQt5.qt5ct
      libsForQt5.qtstyleplugins
      nordic
      nordzy-cursor-theme
      nordzy-icon-theme
      themechanger
      # keep-sorted end
    ];

    desktopApps = with pkgs; [
      # keep-sorted start
      arandr
      blueberry
      clipmenu
      dunst
      feh
      font-manager
      gparted
      gthumb
      kdePackages.okular
      ncpamixer
      pavucontrol
      peek
      picom
      rofi
      rofi-power-menu
      simplescreenrecorder
      slack
      xfce.xfce4-screenshooter
      xsel
      zathura
      # keep-sorted end
    ];

    i3wmTools =
      let
        override-bumblebee-status = pkgs.bumblebee-status.override {
          plugins =
            p: with p; [
              # keep-sorted start
              battery
              cpu2
              datetime
              dunstctl
              error
              indicator
              memory
              nic
              title
              # keep-sorted end
            ];
        };
      in
      with pkgs;
      [
        # keep-sorted start
        i3status
        i3status-rust
        override-bumblebee-status
        # keep-sorted end
      ];
  };

  macOs = with pkgs; [
    # keep-sorted start
    aerospace
    # keep-sorted end
  ];
}
