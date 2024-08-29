{ greeterName, ... }:
{
  imports = [
    ./lightdm-${greeterName}.nix
  ];
  services.xserver.displayManager.lightdm = {
    enable = true;
  };
}
