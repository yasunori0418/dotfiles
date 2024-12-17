{ hostName, ... }:
{
  networking = {
    inherit hostName;
    firewall.enable = true;

    # Enable networking
    networkmanager.enable = true;
  };
}
