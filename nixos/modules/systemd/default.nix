{ pkgs, ... }:
let
  polkit-authentication-kde-agent = import ./polkit-kde-agent.nix { inherit pkgs; };
in
{
  user.services = {
    inherit polkit-authentication-kde-agent;
  };
}
