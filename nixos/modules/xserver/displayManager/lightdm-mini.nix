{ ... }:
{
  services.xserver.displayManager.lightdm.greeters.mini = {
    enable = true;
    user = "yasunori";
    extraConfig = builtins.readFile ./lightdm-mini-greeter.conf;
  };
}
