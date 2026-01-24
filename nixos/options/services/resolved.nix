{ config, ... }:
{
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = true;
      DNSOverTLS = true;
      FallbackDNS = config.networking.nameservers;
    };
  };
}
