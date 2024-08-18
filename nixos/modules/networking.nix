{ hostName, ... }:
{
  hostName = hostName;
  firewall.enable = true;

  # Enable networking
  networkmanager.enable = true;
}
