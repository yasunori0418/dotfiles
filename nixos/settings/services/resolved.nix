{ config, ... }:
{
  services.resolved = {
    enable = true;
    dnssec = "true";
    dnsovertls = "true";
    fallbackDns = config.networking.nameservers;
  };
}
