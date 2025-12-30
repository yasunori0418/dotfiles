{ pkgs, ... }:
{
  systemd.user.services.initial-dotfiles-clone = {
    description = "Initial clone of dotfiles repository";
    enable = true;
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    # dotfilesディレクトリが存在しない場合のみ実行
    unitConfig = {
      ConditionPathExists = "!%h/dotfiles";
    };

    script = ''
      DOTFILES_DIR="$HOME/dotfiles"

      ${pkgs.git}/bin/git clone https://github.com/yasunori0418/dotfiles.git "$DOTFILES_DIR"

      cd "$DOTFILES_DIR"
      ${pkgs.coreutils}/bin/cp example.env .env
      ${pkgs.coreutils}/bin/cp example.envrc .envrc

      ${pkgs.coreutils}/bin/echo "Initial dotfiles setup completed successfully"
    '';
  };
}
