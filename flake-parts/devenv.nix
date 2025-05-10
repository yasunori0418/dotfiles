# The importApply argument. Use this to reference things defined locally,
# as opposed to the flake where this is imported.
localFlake:

# Regular module arguments; self, inputs, etc all reference the final user flake,
# where this module was imported.
_: {
  perSystem =
    { pkgs, config, ... }:
    {
      devenv = {
        shells.default = {
          packages = with pkgs; [
            vim-startuptime
            tokei
            hyperfine
            stylua
            luajitPackages.luacheck
            luajitPackages.vusted
            luajitPackages.luacov
            checkmake
          ];

          scripts = {
            list =
              let
                inherit (pkgs) lib;
              in
              {
                exec = ''
                  echo
                  echo 🦾 Helper scripts you can run to make your development richer:
                  echo 🦾
                  ${pkgs.gnused}/bin/sed -e 's| |••|g' -e 's|=| |' <<EOF \
                  | ${pkgs.util-linuxMinimal}/bin/column -t | ${pkgs.gnused}/bin/sed -e 's|^|🦾 |' -e 's|••| |g'
                  ${lib.generators.toKeyValue { } (
                    lib.mapAttrs (name: value: value.description) config.devenv.shells.default.scripts
                  )}
                  EOF
                  echo
                '';
                description = "devenvで定義したのscripts一覧";
              };
          };
        };
      };
    };
}
