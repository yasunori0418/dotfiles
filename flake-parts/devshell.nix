# The importApply argument. Use this to reference things defined locally,
# as opposed to the flake where this is imported.
localFlake:

# Regular module arguments; self, inputs, etc all reference the final user flake,
# where this module was imported.
_: {
  perSystem =
    { inputs', pkgs, ... }:
    {
      devShells = {
        default = pkgs.mkShell {
          packages = with pkgs; [
            vim-startuptime
            tokei
            hyperfine
            stylua
            luajitPackages.luacheck
            luajitPackages.vusted
            luajitPackages.luacov
            checkmake
            emmylua-ls
            ts_query_ls
            # mattpocock/skills を .claude/skills/ へ配置する nput（project mode 用に pin）
            inputs'.nput.packages.nput
          ];
          shellHook = ''
            nput apply skills --no-wait
          '';
        };
      };
    };
}
