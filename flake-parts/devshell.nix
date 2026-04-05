# The importApply argument. Use this to reference things defined locally,
# as opposed to the flake where this is imported.
localFlake:

# Regular module arguments; self, inputs, etc all reference the final user flake,
# where this module was imported.
_: {
  perSystem =
    { pkgs, ... }:
    {
      devShells = {
        default = pkgs.mkShell {
          packages = with pkgs; [
            vim-startuptime
            tokei
            hyperfine
            stylua
            luajitPackages.luacheck
            # see: https://github.com/NixOS/nixpkgs/pull/503777
            # see: https://nixpk.gs/pr-tracker.html?pr=503777
            # luajitPackages.vusted
            luajitPackages.luacov
            checkmake
            emmylua-ls
            ts_query_ls
          ];
        };
      };
    };
}
