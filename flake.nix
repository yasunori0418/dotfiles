{
  description = "My dotfiles, all my wisdom, my castle.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    mac-app-util.url = "github:hraban/mac-app-util";
    yasunori-nur.url = "github:yasunori0418/nur-packages";
    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    xremap-flake = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents-nix = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
    nix-claude-code = {
      url = "github:ryoppippi/nix-claude-code";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cryoflow.url = "github:yasunori0418/cryoflow";
    arto.url = "github:arto-app/Arto";
    cclens.url = "github:lambdalisue/cclens";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nput = {
      url = "github:yasunori0418/nput";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        home-manager.follows = "home-manager";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    # Claude Code 用スキル集（mattpocock/skills）。nput の project mode で
    # .claude/skills/ へ配置するため flake=false。flake.lock が rev を pin する。
    matt-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };
    # 自作 Claude Code スキル・エージェント集（yasunori0418/skills）。nput（HM 側）で
    # ~/.claude/skills / ~/.claude/agents へ配置するため flake=false。flake.lock が rev を pin する。
    yasunori-skills = {
      url = "github:yasunori0418/skills";
      flake = false;
    };
    # tirith 公式リポジトリ。crates/tirith/assets/hooks/tirith-check.py を
    # nput 経由で ~/.claude/hooks/tirith/tirith-check.py へ symlink 配置し、
    # cchook から uv 経由で呼び出す。flake.lock が rev を pin する。
    tirith = {
      url = "github:sheeki03/tirith";
      flake = false;
    };
    herdr = {
      url = "github:herdrdev/herdr";
      flake = false;
    };
    # herdr プラグイン。herdr はプラグインをディレクトリ走査で発見せず
    # ~/.config/herdr/plugins.json（レジストリ）に登録された plugin_root の
    # 絶対パスを見る。よって derivation でビルド・整形 → nput で
    # ~/.local/share/herdr-plugins/ へ配置 → `herdr plugin link` で登録する。
    # marketplace の `herdr plugin install` は使わない（managed checkout が
    # Nix 管理外になるため）。更新は flake.lock の rev 更新 + switch。
    # ref は指定せず default branch を追う（rev の pin は flake.lock が担う）。
    # 更新は `nix flake update herdr-<name>` + switch。
    # なお herdr-navigator（Rust）と herdr-plus（Go）は依存の固定ハッシュを持つ
    # ため、更新で Cargo.lock / go.sum が変わると packages/*.nix の
    # cargoHash / vendorHash が合わなくなりビルドが落ちる。そのときは
    # hash mismatch が出す `got:` の値へ差し替える
    # （`make nput-dryrun` で switch 前に検出できる）。
    herdr-worktrunk = {
      url = "github:devashish2203/herdr-worktrunk";
      flake = false;
    };
    herdr-navigator = {
      url = "github:thanhdat77/herdr-navigator";
      flake = false;
    };
    herdr-plus = {
      url = "github:cloudmanic/herdr-plus";
      flake = false;
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://cache.numtide.com"
      "https://yasunori0418.cachix.org"
      "https://ryoppippi.cachix.org"
      "https://arto.cachix.org"
      "https://cclens.cachix.org"
    ];

    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "yasunori0418.cachix.org-1:mC1j+M5A6063OHaOB5bH2nS0BiCW/BJsSRiOWjLeV9o="
      "ryoppippi.cachix.org-1:b2LbtWNvJeL/qb1B6TYOMK+apaCps4SCbzlPRfSQIms="
      "arto.cachix.org-1:yaH0JQomRJTosIcTh2xZPKBEny41D7h6QUePYQzWYqc="
      "cclens.cachix.org-1:0QUNU6PuVyf+yXOvg3n1rd3FksBoB3s3/Jty50iKRNQ="
    ];
  };

  outputs =
    {
      # self,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, flake-parts-lib, ... }:
      let
        # ref: https://flake.parts/dogfood-a-reusable-module.html?highlight=imports#example-with-importapply
        importApply =
          nixPath:
          let
            inherit (flake-parts-lib) importApply;
          in
          importApply nixPath { inherit withSystem; };
      in
      {
        imports =
          let
            treefmt.default = importApply ./flake-parts/treefmt.nix;
            devshell.default = importApply ./flake-parts/devshell.nix;
            nput.default = importApply ./flake-parts/nput.nix;
          in
          [
            inputs.treefmt-nix.flakeModule
            inputs.nput.flakeModules.default
            treefmt.default
            devshell.default
            nput.default
          ];
        systems = import inputs.systems;
        flake =
          let
            args =
              targetSystem:
              let
                f =
                  { profileName, system }:
                  import ./${targetSystem} {
                    inherit inputs profileName system;
                  };
              in
              f;
          in
          {
            nixosConfigurations =
              let
                inherit (inputs.nixpkgs.lib) nixosSystem;
                nixosArgs = args "nixos";
                system = "x86_64-linux";
              in
              {
                yasunori-laptop = nixosSystem (nixosArgs {
                  profileName = "ThinkPadE14Gen2";
                  inherit system;
                });
                yasunori-laptop2 = nixosSystem (nixosArgs {
                  profileName = "ThinkPadP14sGen6";
                  inherit system;
                });
                yasunori-desktop = nixosSystem (nixosArgs {
                  profileName = "Desktop";
                  inherit system;
                });
                iso = nixosSystem {
                  inherit system;
                  modules = [
                    "${inputs.nixpkgs.outPath}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
                    ./nixos/iso
                  ];
                };
              };

            homeConfigurations =
              let
                inherit (inputs.home-manager.lib) homeManagerConfiguration;
                hmArgs = args "home-manager";
              in
              {
                linux = homeManagerConfiguration (hmArgs {
                  profileName = "linux";
                  system = "x86_64-linux";
                });
                macos = homeManagerConfiguration (hmArgs {
                  profileName = "macos";
                  system = "aarch64-darwin";
                });
              };

            darwinConfigurations =
              let
                inherit (inputs.nix-darwin.lib) darwinSystem;
                darwinArgs = args "nix-darwin";
                system = "aarch64-darwin";
              in
              {
                LGPM-0151 = darwinSystem (darwinArgs {
                  profileName = "lg-darwin";
                  inherit system;
                });
              };

          };
      }
    );
}
