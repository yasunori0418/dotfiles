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
      [[ ! -d ${dotfiles} ]] && ${pkgs.git}/bin/git clone https://github.com/yasunori0418/dotfiles.git ${dotfiles}
    '';
}
