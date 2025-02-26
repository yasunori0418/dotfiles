# The importApply argument. Use this to reference things defined locally,
# as opposed to the flake where this is imported.
localFlake:

# Regular module arguments; self, inputs, etc all reference the final user flake,
# where this module was imported.
_: {
  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";
        programs = {
          beautysh = {
            enable = true;
            indent_size = 4;
          };
          nixfmt = {
            enable = true;
            package = pkgs.nixfmt-rfc-style;
          };
          stylua = {
            enable = true;
            settings = {
              call_parentheses = "Always";
              collapse_simple_statement = "Never";
              column_width = 120;
              indent_type = "Spaces";
              indent_width = 4;
              line_endings = "Unix";
              quote_style = "AutoPreferDouble";
              sort_requires.enabled = false;
            };
          };
          statix = {
            enable = true;
            excludes = [
              ".direnv"
              "hardware-configuration.nix"
            ];
          };
          deno = {
            enable = true;
            includes = [
              "home/.config/nvim"
              "home/.config/vim"
            ];
          };
        };
      };
    };
}
