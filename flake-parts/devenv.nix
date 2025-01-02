# The importApply argument. Use this to reference things defined locally,
# as opposed to the flake where this is imported.
localFlake:

# Regular module arguments; self, inputs, etc all reference the final user flake,
# where this module was imported.
_: {
  perSystem =
    { pkgs, ... }:
    {
      devenv = {
        shells.default = {
          packages = with pkgs; [
            vim-startuptime
            tokei
            hyperfine
            stylua
            luajitPackages.luacheck
            checkmake
            lua-language-server
          ];
        };
      };
    };
}
