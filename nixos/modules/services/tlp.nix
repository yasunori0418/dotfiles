{
  enable = true;
  settings = {
    TLP_DEFAULT_MODE = "BAT";

    # Battery Care
    # Refer: https://linrunner.de/tlp/settings/battery.html
    START_CHARGE_THRESH_BAT0 = 30;
    STOP_CHARGE_THRESH_BAT0 = 90;
    START_CHARGE_THRESH_BAT1 = 30;
    STOP_CHARGE_THRESH_BAT1 = 90;
    # Control battery care drivers:
    NATACPI_ENABLE = 1;
    TPACPI_ENABLE = 1;
    TPSMAPI_ENABLE = 1;

    # Disks and Controllers
    DISK_APM_LEVEL_ON_AC = "254 254";
    DISK_APM_LEVEL_ON_BAT = "128 128";
    SATA_LINKPWR_ON_AC = "med_power_with_dipm";
    SATA_LINKPWR_ON_BAT = "med_power_with_dipm";
    AHCI_RUNTIME_PM_ON_AC = "on";
    AHCI_RUNTIME_PM_ON_BAT = "auto";

    # Networking
    WIFI_PWR_ON_AC = "off";
    WIFI_PWR_ON_BAT = "on";
  };
}
