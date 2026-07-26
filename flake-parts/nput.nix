# nput の配置 config をまとめる flake-parts module。
# nput の flakeModules.default（flake.nix の imports が読む）を前提に、
# perSystem.nput.<name> へ manifest を宣言する。宣言したものは
# flake.nput.<system>.<name> へ転置され、`nput apply <name>` から直接叩ける。
#
# - default: home mode（root = homeRoot）。~/.claude/* や ~/.config/* の配置。
#   entries は home-manager 側（home-manager/{linux,macos}/nput.nix）と
#   ../home-manager/nputEntries.nix を共有するので内容は完全に一致する。
#   名前を `default` にしているのは HM モジュールの activation
#   （`nput apply --manifest <path>`・位置引数なし = profile 名 `default`）と
#   同じ generation profile（<state>/nix/profiles/nput/default）へ載せるため。
#   別名にすると CLI 適用と HM activation が別 profile になり、同じ配置先を
#   互いに奪い合って stale 削除が壊れる。
#   これにより `nput apply --recopy`（settings.json の copy 再配置）が
#   home-manager switch を挟まずに Makefile から叩ける。
#
# - skills: project mode（root = projectRoot）。mattpocock/skills を
#   .claude/skills/<name> へ配置する。devShell の shellHook
#   （flake-parts/devshell.nix）が `nput apply skills` でビルド・配置する。
#   配置物は .gitignore 済みの ephemeral。

# The importApply argument. Use this to reference things defined locally,
# as opposed to the flake where this is imported.
localFlake:

# Regular module arguments; self, inputs, etc all reference the final user flake,
# where this module was imported.
{ inputs, ... }:
let
  nputLib = inputs.nput.lib;

  # home mode の entries は out-of-store symlink の src に $HOME の絶対パスを
  # 埋めるため、system ごとにユーザー名 / home ディレクトリを解決する。
  # 値は home-manager/{linux,macos}/default.nix の home.username /
  # home.homeDirectory と一致させること（ズレると配置先が食い違う）。
  homeDirectoryFor =
    system: if isDarwinSystem system then "/Users/taiki.watanabe" else "/home/yasunori";
  isDarwinSystem = system: builtins.match ".*-darwin" system != null;

  # 展開する skill を明示列挙する（mattpocock/skills の skills/ 配下の相対パス）。
  skillSubpaths = [
    "engineering/grill-with-docs"
    "engineering/improve-codebase-architecture"
    "engineering/prototype"
    "engineering/setup-matt-pocock-skills"
    "engineering/tdd"
    "engineering/to-tickets"
    "engineering/to-spec"
    "engineering/triage"
    "productivity/grilling"
    "productivity/handoff"
  ];

  # skill ごとに { ".claude/skills/<name>" = entry; } を組む。
  # target = .claude/skills/<skill 名>、配置元は skills/<category>/<name> の subpath。
  skillEntries = builtins.listToAttrs (
    map (p: {
      name = ".claude/skills/${baseNameOf p}";
      value = {
        src = inputs.matt-skills;
        subpath = "skills/${p}";
      };
    }) skillSubpaths
  );
in
{
  perSystem =
    { pkgs, system, ... }:
    {
      # perSystem.nput.<name> → flake.nput.<system>.<name> へ自動転置される（nput flakeModule）。
      nput = {
        default = nputLib.mkManifest {
          inherit pkgs;
          root = nputLib.homeRoot;
          entries = import ../home-manager/nputEntries.nix {
            inherit inputs pkgs;
            homeDirectory = homeDirectoryFor system;
            isDarwin = isDarwinSystem system;
          };
        };

        skills = nputLib.mkManifest {
          inherit pkgs;
          root = nputLib.projectRoot;
          entries = skillEntries;
        };
      };
    };
}
