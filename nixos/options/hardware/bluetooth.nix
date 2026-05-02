{ pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Intel BE201 は Bluetooth 5.4 対応
        Experimental = true;
      };
    };
  };

  services.blueman.enable = true;
  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
  ];
}
