# Refer: https://nixos.wiki/wiki/Nvidia
{ config, pkgs, ... }:
{
  hardware = {
    graphics.enable = true;
    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking up from sleep.
      # This fixes it by saving the entire VRAM memory to /tmp/ instead of just the bare essentials.
      powerManagement.enable = true;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures.
      # Full list of supported GPUs is at: https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package =
        let
          inherit (config.boot.kernelPackages.nvidiaPackages) mkDriver production;
          v580-95-05 = mkDriver {
            version = "580.95.05";
            sha256_64bit = "sha256-hJ7w746EK5gGss3p8RwTA9VPGpp2lGfk5dlhsv4Rgqc=";
            sha256_aarch64 = null;
            openSha256 = "sha256-RFwDGQOi9jVngVONCOB5m/IYKZIeGEle7h0+0yGnBEI=";
            settingsSha256 = "sha256-F2wmUEaRrpR1Vz0TQSwVK4Fv13f3J9NJLtBe4UP2f14=";
            persistencedSha256 = "sha256-QCwxXQfG/Pa7jSTBB0xD3lsIofcerAWWAHKvWjWGQtg=";
          };
          v580-105-08 = mkDriver {
            version = "580.105.08";
            sha256_64bit = "sha256-2cboGIZy8+t03QTPpp3VhHn6HQFiyMKMjRdiV2MpNHU=";
            sha256_aarch64 = null;
            openSha256 = "sha256-FGmMt3ShQrw4q6wsk8DSvm96ie5yELoDFYinSlGZcwQ=";
            settingsSha256 = "sha256-YvzWO1U3am4Nt5cQ+b5IJ23yeWx5ud1HCu1U0KoojLY=";
            persistencedSha256 = "sha256-qh8pKGxUjEimCgwH7q91IV7wdPyV5v5dc5/K/IcbruI=";
          };
          v570-207 = mkDriver {
            version = "570.207";
            sha256_64bit = "sha256-LWvSWZeWYjdItXuPkXBmh/i5uMvh4HeyGmPsLGWJfOI=";
            sha256_aarch64 = null;
            openSha256 = "sha256-/E/q4N4eDelHKUApNmKBl+3IMwZGjwdo8eYQTTXdNHI=";
            settingsSha256 = "sha256-khyOoXAp9FY4Yf6//dwnqxCqQQjWe2OESrNIoJAe0go=";
            persistencedSha256 = "sha256-DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD=";
          };
        in
        production;

      # Refer: https://nixos.wiki/wiki/Nvidia#Configuring_Optimus_PRIME:_Bus_ID_Values_.28Mandatory.29
      prime =
        let
          # VERY VERY EXPERIMENTAL!!
          displayBusId =
            vendor:
            builtins.readFile (
              pkgs.runCommand "display-bus-id"
                {
                  buildInputs = with pkgs; [
                    pciutils
                    gnused
                    gnugrep
                    coreutils
                  ];
                }
                ''
                  for i in $(lspci | grep -i 'vga' | grep -i '${vendor}' | cut -d ' ' -f1 | sed -e 's/[:\.]/ /g')
                          do
                          echo $((16#$i))
                        done | paste -sd ':' | xargs -I{} printf 'PCI:{}' > $out ''
            );
        in
        {
          sync.enable = true;
          nvidiaBusId = displayBusId "nvidia"; # "PCI:1:0:0"
          amdgpuBusId = displayBusId "amd"; # "PCI:17:0:0"
        };
    };
  };
  boot = {
    initrd.kernelModules = [ "nvidia" ];
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
    extraModprobeConfig = ''
      options nvidia NVreg_PreserveVideoMemoryAllocations=1
    '';
  };
}
