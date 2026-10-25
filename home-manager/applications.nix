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
  optionalIsLinux = optional pkgs.stdenv.hostPlatform.isLinux;
  optionalIsDarwin = optional pkgs.stdenv.hostPlatform.isDarwin;
  inherit (pkgs.stdenv.hostPlatform) system;
  myNurPkgs = inputs.yasunori-nur.packages.${system};
  llmAgentsPkgs = inputs.llm-agents-nix.packages.${system};
  claude-code-by-ryoppippi = inputs.nix-claude-code.packages.${system}.default;
  cryoflow = inputs.cryoflow.packages.${system}.default;
  arto = inputs.arto.packages.${system}.default;
  cclens = inputs.cclens.packages.${system}.default;
  nvimOverlay = inputs.neovim-nightly-overlay.packages.${system}.neovim;
  nordic-darker = pkgs.callPackage ./packages/nordic-darker.nix { };
  # with pkgs より let 束縛が優先されるため、codingSupportTools の textlint はこちらを指す。
  textlint = pkgs.callPackage ./packages/textlint.nix { };

  # nixpkgs の chromium は Linux 専用で、darwin では PUPPETEER_EXECUTABLE_PATH が設定されず
  # puppeteer が chrome-headless-shell を探して失敗する。darwin だけ既存の Google Chrome を指す。
  mermaid-cli =
    if pkgs.stdenv.hostPlatform.isDarwin then
      pkgs.mermaid-cli.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
        postFixup = (old.postFixup or "") + ''
          wrapProgram $out/bin/mmdc \
            --set-default PUPPETEER_EXECUTABLE_PATH "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
        '';
      })
    else
      pkgs.mermaid-cli;

  # home-manager で入れた gparted の polkit アクション(exec.allow_gui 付き)は polkitd が読む
  # system profile に載らず、汎用の org.freedesktop.policykit.exec に落ちて表示用の環境変数が
  # 消される。pkexec env で Wayland の接続先を明示的に渡し、root 化済みの gparted を起動する。
  # rofi は起動したプロセスを切り離すため、exec すると pkexec の親が init になり
  # "Refusing to render service to dead parents." で拒否される。シェルを親として残す。
  gparted =
    let
      launcher = pkgs.writeShellScript "gparted" ''
        /run/wrappers/bin/pkexec --disable-internal-agent ${pkgs.coreutils}/bin/env \
          WAYLAND_DISPLAY="$XDG_RUNTIME_DIR/''${WAYLAND_DISPLAY:-wayland-0}" \
          ${pkgs.gparted}/bin/gparted "$@"
      '';
    in
    pkgs.symlinkJoin {
      name = "gparted-pkexec-${pkgs.gparted.version}";
      paths = [ pkgs.gparted ];
      postBuild = ''
        rm $out/bin/gparted $out/share/applications/gparted.desktop
        ln -s ${launcher} $out/bin/gparted
        sed 's|^Exec=.*|Exec=${launcher} %f|' \
          ${pkgs.gparted}/share/applications/gparted.desktop > $out/share/applications/gparted.desktop
      '';
    };
in
{
  nixTools = with pkgs; [
    # keep-sorted start
    cachix
    nh
    nix-direnv
    nix-output-monitor
    nix-search-cli
    nix-sweep
    # keep-sorted end
  ];

  utilityTools =
    with pkgs;
    [
      # keep-sorted start
      awscli2
      coreutils-full
      cryoflow
      direnv
      flock
      gh
      git
      git-credential-oauth
      git-lfs
      gnumake
      lefthook
      lemonade
      llmAgentsPkgs.herdr
      mermaid-cli # let で darwin 向けに上書き
      mise
      myNurPkgs.deno
      myNurPkgs.pict
      myNurPkgs.roots
      myNurPkgs.safe-chain
      myNurPkgs.worktrunk
      python313Packages.datadog
      ssm-session-manager-plugin
      tirith
      tree-sitter
      typos
      unar
      unzip
      usql
      zip
      # keep-sorted end
    ]
    ++ (optionalIsLinux [ clipcat ]);

  textEditors = with pkgs; [
    # keep-sorted start
    # emacs
    myNurPkgs.vim-overlay
    # neovide
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
    curlFull
    dasel
    delta
    eza
    fd
    fish
    fzf
    ghq
    jq
    nushell
    rgx
    rip2
    ripgrep
    sheldon
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
    beautysh
    eslint_d
    nixfmt
    prettierd
    ruff
    shellcheck
    sqruff
    statix
    textlint
    # keep-sorted end
  ];

  aiTools = with llmAgentsPkgs; [
    # keep-sorted start
    cclens
    ccusage
    claude-code-by-ryoppippi
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
    # cargo-watch
    clippy
    crate2nix
    rust-analyzer
    rust.packages.stable.rustc-unwrapped
    rustfmt
    # keep-sorted end
  ];

  guiTools =
    with pkgs;
    [
      # keep-sorted start
      arto
      drawio
      postman
      # keep-sorted end
    ]
    ++ (optionalIsLinux [ google-chrome ]);

  linuxDesktop = {
    theme = [
      nordic-darker
    ]
    ++ (with pkgs; [
      # keep-sorted start
      glib
      libsForQt5.qt5ct
      libsForQt5.qtstyleplugins
      nordzy-cursor-theme
      nordzy-icon-theme
      # keep-sorted end
    ]);

    desktopApps = with pkgs; [
      # keep-sorted start
      blueman
      brightnessctl
      clipmenu
      dunst
      feh
      # font-manager
      fuzzel
      gimp
      gparted # let で pkexec 経由に上書き
      grim
      gthumb
      kdePackages.okular
      nwg-displays
      pavucontrol
      peek
      rofi
      rofi-power-menu
      showmethekey
      slack
      slurp
      sway-contrib.grimshot
      swaybg
      swaylock-effects
      vlc
      waybar
      wl-clipboard
      wl-screenrec
      wlr-randr
      xwayland
      xwayland-satellite
      zathura
      # zoom-us
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
