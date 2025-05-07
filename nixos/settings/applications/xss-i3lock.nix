{ pkgs, ... }:
{
  programs = {
    i3lock = {
      package = pkgs.i3lock-color;
      enable = true;
    };
    xss-lock = {
      enable = true;
      extraOptions = [
        "--transfer-sleep-lock"
      ];
      # Refer: https://github.com/Raymo111/i3lock-color/blob/master/examples/lock_bar.sh
      lockerCommand = ''
        ${pkgs.i3lock-color}/bin/i3lock-color \
        --ignore-empty-password \
        --blur 5 \
        --bar-indicator \
        --bar-pos y+h \
        --bar-direction 1 \
        --bar-max-height 50 \
        --bar-base-width 50 \
        --bar-color 000000cc \
        --keyhl-color 880088cc \
        --bar-periodic-step 50 \
        --bar-step 50 \
        --redraw-thread \
        \
        --clock \
        --force-clock \
        --time-pos x+5:y+h-80 \
        --time-color 880088ff \
        --date-pos tx:ty+15 \
        --date-color 990099ff \
        --date-align 1 \
        --date-str="%%Y/%%m/%%d\n%%A" \
        --time-align 1 \
        --time-str="%%H:%%M:%%S" \
        --ringver-color 8800ff88 \
        --ringwrong-color ff008888 \
        --status-pos x+5:y+h-16 \
        --verif-align 1 \
        --wrong-align 1 \
        --verif-color ffffffff \
        --wrong-color ffffffff \
        --modif-pos -50:-50
      '';
    };
  };
}
