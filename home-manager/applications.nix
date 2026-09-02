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
    # keep-sorted end
  ];

  aiTools = with llmAgentsPkgs; [
    # keep-sorted start
    cclens
    ccusage
    claude-code-by-ryoppippi
    myNurPkgs.cchook
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
      gparted
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
        override-bumblebee-status =
          (pkgs.bumblebee-status.override {
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
          }).overrideAttrs
            (old: {
              # Python 3.14 で setuptools が site-packages から外れ、
              # zpool.py の `from pkg_resources import parse_version` が
              # ModuleNotFoundError になる。checkPhase の全モジュール走査で
              # zpool.py が import され、ビルドが失敗する。
              # 原因の 1 行を packaging.version へ置換して回避する。
              #
              # 併せて setup.py の versioneer.get_version() を固定文字列に置換する。
              # 上流は versioneer で git tag から version を取得するが、fetchFromGitHub の
              # tarball には .git が無く `0+unknown` になる。新しい pythonMetadataCheckPhase が
              # derivation の version ("2.2.0") と METADATA の version の不一致を検出して失敗する。
              # pyproject.toml が存在しないため pyprojectVersionPatchHook は使えないので
              # setup.py を直接パッチする。
              postPatch = (old.postPatch or "") + ''
                substituteInPlace bumblebee_status/modules/contrib/zpool.py \
                  --replace-fail \
                    'from pkg_resources import parse_version' \
                    'from packaging.version import parse as parse_version'

                substituteInPlace setup.py \
                  --replace-fail \
                    'version=versioneer.get_version(),' \
                    'version="${old.version}",' \
                  --replace-fail \
                    'cmdclass=versioneer.get_cmdclass(),' \
                    ""
              '';
              propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
                pkgs.python3Packages.packaging
              ];
            });
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
