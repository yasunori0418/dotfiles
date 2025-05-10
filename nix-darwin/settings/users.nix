{ name, pkgs, ... }:
{
  users.users.${name} = {
    inherit name;
    home = "/Users/${name}";
    shell = pkgs.zsh;
    description = "nix user";
    createHome = true;
  };
}
