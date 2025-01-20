{
  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;
    hostName = "yasunori-macx64OrbStack";
  };
  systemd.network = {
    enable = true;
    networks."50-eth0" = {
      matchConfig.Name = "eth0";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };
}
