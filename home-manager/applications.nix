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
  claude-code-by-ryoppippi = inputs.nix-claude-code.packages.${system}.default;
  cryoflow = inputs.cryoflow.packages.${system}.default;
  arto = inputs.arto.packages.${system}.default;
  nvimOverlay = inputs.neovim-nightly-overlay.packages.${system}.neovim;
in
{
  nixTools = with pkgs; [
    # keep-sorted start
    cachix
    nix-direnv
    nix-output-monitor
    nix-prefetch-github
    nix-search-cli
    nix-sweep
    # keep-sorted end
  ];

  utilityTools =
    with pkgs;
    [
      # keep-sorted start
      act
      asciinema
      asciinema-agg
      awscli2
      colorized-logs
      cryoflow
      direnv
      flock
      fx
      gh
      git
      git-credential-oauth
      git-lfs
      git-wt
      glow
      gnumake
      google-cloud-sdk
      gws
      kanata-with-cmd
      lazysql
      lefthook
      lemonade
      lnav
      mise
      myNurPkgs.deno
      myNurPkgs.pict
      myNurPkgs.roots
      myNurPkgs.safe-chain
      myNurPkgs.worktrunk
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
    ++ (optionalIsLinux [ clipcat ]);

  textEditors = with pkgs; [
    # keep-sorted start
    emacs
    myNurPkgs.vim-overlay
    neovide
    neovim-remote
    nvimOverlay
    # keep-sorted end
  ];

  terminalEmulators =
    with pkgs;
    [
      # keep-sorted start
      alacritty
      kitty
      wezterm
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
    fish
    fzf
    ghq
    jq
    nushell
    ov
    rgx
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
    myNurPkgs.kotlin-lsp
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

  aiTools = with llmAgentsPkgs; [
    # keep-sorted start
    amp
    ccusage
    claude-code-by-ryoppippi
    codex
    goose-cli
    myNurPkgs.cchook
    rtk
    # claude-code # use `github:ryoppippi/claude-code-overlay`
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

  guiTools =
    with pkgs;
    [
      # keep-sorted start
      arto
      discord
      drawio
      jetbrains-toolbox
      postman
      # keep-sorted end
    ]
    ++ (optionalIsLinux [ google-chrome ]);

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
      blueman
      brightnessctl
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
      showmethekey
      simplescreenrecorder
      slack
      slurp
      sway-contrib.grimshot
      swaybg
      swaylock-effects
      vlc
      waybar
      wf-recorder
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
