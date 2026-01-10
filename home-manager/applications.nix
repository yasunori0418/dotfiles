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
  inherit (pkgs.stdenv.hostPlatform) system;
  myNurPkgs = inputs.yasunori-nur.packages.${system};
  llmAgentsPkgs = inputs.llm-agents-nix.packages.${system};
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
    clipcat
    colorized-logs
    deno
    direnv
    flock
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
    myNurPkgs.pict
    myNurPkgs.safe-chain
    pqrs
    pueue
    python313Packages.datadog
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
  ]
  # ++ (optionalIsLinux [ inputs.zmx.packages.${pkgs.stdenv.hostPlatform.system}.default ])
  ;

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
    zoxide
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
    # actionlint
    beautysh
    biome
    blade-formatter
    eslint_d
    nixfmt
    prettierd
    ruff
    shellcheck
    sqruff
    statix
    # keep-sorted end
  ];

  aiTools = with pkgs; [
    # keep-sorted start
    codex
    myNurPkgs.cc-sdd
    myNurPkgs.ccexp
    myNurPkgs.cchook
    llmAgentsPkgs.ccusage
    llmAgentsPkgs.goose-cli
    llmAgentsPkgs.amp
    # llmAgentsPkgs.claude-code # use `github:ryoppippi/claude-code-overlay`
    # keep-sorted end
  ]
  # ++ (optionalIsLinux [ inputs.claude-desktop.packages.${system}.claude-desktop ])
  ;

  libraries =
    with pkgs;
    [
      # keep-sorted start
      bun
      go
      nodejs_24
      perl
      pnpm
      python312Packages.uv
      ruby
      volta
      # keep-sorted end
    ]
    ++ (optionalIsLinux [ gcc ])
    ++ (optionalIsDarwin [
      llvmPackages.clangWithLibcAndBasicRtAndLibcxx
      darwin.libiconv
    ]);

  rustTools = with pkgs; [
    # keep-sorted start
    cargo
    cargo-make
    cargo-watch
    clippy
    crate2nix
    rust-analyzer
    rust.packages.stable.rustc-unwrapped
    rustfmt
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
      glib
      libsForQt5.qt5ct
      libsForQt5.qtstyleplugins
      nordic
      nordzy-cursor-theme
      nordzy-icon-theme
      nwg-look
      themechanger
      # keep-sorted end
    ];

    desktopApps = with pkgs; [
      # keep-sorted start
      blueberry
      clipmenu
      dunst
      feh
      font-manager
      fuzzel
      gimp
      gparted
      grim
      gthumb
      kdePackages.okular
      ncpamixer
      nwg-displays
      pavucontrol
      peek
      picom
      rofi
      rofi-power-menu
      simplescreenrecorder
      slack
      slurp
      swaybg
      vlc
      waybar
      wl-clipboard
      wl-screenrec
      wlr-randr
      xfce4-screenshooter
      xwayland
      xwayland-satellite
      zathura
      zoom-us
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
