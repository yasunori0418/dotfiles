# layat の配置 config をまとめる flake-parts module。
# layat の flakeModules.default（flake.nix の imports が読む）を前提に、
# perSystem.layat.<name> へ manifest を宣言する。宣言したものは
# flake.layat.<system>.<name> へ転置され、`layat apply <name>` から直接叩ける。
#
# - home mode（root = homeRoot）の profile 群（home / desktop / vim / claude /
#   claude-settings / herdr-plugins）: entries は home-manager 側
#   （home-manager/layat/default.nix）と ../home-manager/layat/entries.nix を共有するので
#   内容・subdir・profile 名は完全に一致する（subdir は HM モジュールの
#   `configs.<name>.subdir` と同じく `homeRoot { subdir }` の適用形で渡す）。
#   HM モジュールの activation（`layat apply --all --manifest <name>=<link-farm> …`）と
#   同じ generation profile（<state>/nix/profiles/layat/<name>）へ載せるため、名前を揃えることが必須。
#   別名にすると CLI 適用と HM activation が別 profile になり、同じ配置先を
#   互いに奪い合って stale 削除が壊れる。
#   これにより `make layat-apply` / `make layat-recopy`（claude-settings の copy 再配置）が
#   home-manager switch を挟まずに叩ける。
#
# - skills: project mode（root = projectRoot）。mattpocock/skills を
#   .claude/skills/<name> へ配置する。devShell の shellHook
#   （flake-parts/devshell.nix）が `layat apply skills` でビルド・配置する。
#   配置物は .gitignore 済みの ephemeral。Makefile の `--all --home-root` には
#   乗らない。

# The importApply argument. Use this to reference things defined locally,
# as opposed to the flake where this is imported.
localFlake:

# Regular module arguments; self, inputs, etc all reference the final user flake,
# where this module was imported.
{ inputs, lib, ... }:
let
  layatLib = inputs.layat.lib;

  skillSubpaths = [
    "nix/nix-cache-check"
    "nix/nix-store-lookup"
  ];

  # skill ごとに { ".claude/skills/<name>" = entry; } を組む。
  # target = .claude/skills/<skill 名>、配置元は skills/<category>/<name> の subpath。
  skillEntries = builtins.listToAttrs (
    map (p: {
      name = ".claude/skills/${baseNameOf p}";
      value = {
        src = inputs.yasunori-skills;
        subpath = "skills/${p}";
      };
    }) skillSubpaths
  );
in
{
  perSystem =
    { pkgs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) isDarwin;

      homeConfigs = import ../home-manager/layat/entries.nix {
        inherit inputs pkgs isDarwin;
      };
    in
    {
      # perSystem.layat.<name> → flake.layat.<system>.<name> へ自動転置される（layat flakeModule）。
      layat =
        lib.mapAttrs (
          _:
          { subdir, entries }:
          layatLib.mkManifest {
            inherit pkgs entries;
            # HM モジュールの configs.<name>.subdir と同じ適用形にして manifest を一致させる。
            root = if subdir == null then layatLib.homeRoot else layatLib.homeRoot { inherit subdir; };
          }
        ) homeConfigs
        // {
          skills = layatLib.mkManifest {
            inherit pkgs;
            root = layatLib.projectRoot;
            entries = skillEntries;
          };
        };
    };
}
