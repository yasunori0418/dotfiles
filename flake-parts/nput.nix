# nput（project mode）の配置 config をまとめる flake-parts module。
# nput の flakeModules.default（flake.nix の imports が読む）を前提に、
# perSystem.nput.<name> へ manifest を宣言する（root = projectRoot、repo root 配下へ配置）。
# devShell の shellHook（flake-parts/devshell.nix）が `nput apply <name>` でビルドし、
# store-symlink 配置する。配置物は都度 .gitignore へ追記する ephemeral。
#
# - skills: mattpocock/skills を .claude/skills/<name> へ配置する。

# The importApply argument. Use this to reference things defined locally,
# as opposed to the flake where this is imported.
localFlake:

# Regular module arguments; self, inputs, etc all reference the final user flake,
# where this module was imported.
{ inputs, ... }:
let
  nputLib = inputs.nput.lib;

  # 展開する skill を明示列挙する（mattpocock/skills の skills/ 配下の相対パス）。
  skillSubpaths = [
    "engineering/grill-with-docs"
    "engineering/improve-codebase-architecture"
    "engineering/prototype"
    "engineering/setup-matt-pocock-skills"
    "engineering/tdd"
    "engineering/to-issues"
    "engineering/to-prd"
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
    { pkgs, ... }:
    {
      # perSystem.nput.skills → flake.nput.<system>.skills へ自動転置される（nput flakeModule）。
      nput.skills = nputLib.mkManifest {
        inherit pkgs;
        root = nputLib.projectRoot;
        entries = skillEntries;
      };
    };
}
