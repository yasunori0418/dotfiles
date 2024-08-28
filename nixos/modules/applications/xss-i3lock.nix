{ pkgs, ... }: {
  programs.xss-lock = {
    enable = true;
    extraOptions = [
      "--ignore-sleep"
      "--transfer-sleep-lock"
    ];
    lockerCommand = "${pkgs.i3lock-color}/bin/i3lock-color --ignore-empty-password";
  };
}
