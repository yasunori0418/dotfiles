{ pkgs, ... }:
let
  polkit-authentication-kde-agent = import ./polkit-kde-agent.nix { inherit pkgs; };
  ssh-agent = import ./ssh-agent.nix { inherit pkgs; };
in
{
  user.services = {
    inherit polkit-authentication-kde-agent ssh-agent;
  };
}
