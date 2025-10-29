{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.activation.initialDotfilesCloneAfterOnFilesChange =
    let
      dotfiles = "${config.home.homeDirectory}/dotfiles";
    in
    lib.hm.dag.entryAfter [ "onFilesChange" ] ''
      [[ -d ${dotfiles} ]] && exit 0
      ${pkgs.git}/bin/git clone https://github.com/yasunori0418/dotfiles.git ${dotfiles}
      cd ${dotfiles}
      cp example.env .env
      cp example.envrc .envrc
    '';
}
