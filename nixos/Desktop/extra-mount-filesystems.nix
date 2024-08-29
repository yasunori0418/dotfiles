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

  fileSystems."/music" = {
    device = "/dev/disk/by-label/Music";
    fsType = "ext4";
    options = [
      "users"
      "nofail"
    ];
  };
}
