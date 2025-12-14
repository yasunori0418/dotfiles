{ pkgs, ... }:
{
  systemd.user.services.tmux = {
    Unit = {
      Description = "Tmux main session";
    };

    Service = {
      Type = "forking";
      WorkingDirectory = "%h";
      Environment = [
        "XDG_CONFIG_HOME=%h/.config"
        "XDG_CACHE_HOME=%h/.cache"
        "XDG_DATA_HOME=%h/.local/share"
        "XDG_STATE_HOME=%h/.local/state"
        "XDG_RUNTIME_DIR=/run/user/%U"
      ];
      ExecStart = "${pkgs.tmux}/bin/tmux new-session -d -s main";
      ExecStop = "${pkgs.tmux}/bin/tmux kill-session -t main";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
