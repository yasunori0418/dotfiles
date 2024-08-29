{ ... }:
{
  fileSystems."/data" = {
    device = "/dev/disk/by-label/data";
    fsType = "ntfs-3g";
    options = [
      "users"
      "nofail"
    ];
  };
}
