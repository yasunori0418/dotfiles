{ pkgs, ... }: {
  enable = true;
  extraPackages = with pkgs; [
    i3status
    i3status-rust
    (bumblebee-status.override{
      plugins = p:[
        p.title
        p.cpu2
        p.memory
        p.nic
        p.datetime
        p.battery
        p.dunstctl
        p.indicator
        p.error
      ];
    })
  ];
}
