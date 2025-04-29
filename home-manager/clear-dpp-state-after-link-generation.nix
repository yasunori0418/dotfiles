{
  config,
  lib,
  ...
}:
{
  home.activation.clearDppStateAfterLinkGeneration =
    let
      dppNvimState = "${config.home.homeDirectory}/.cache/dpp/nvim";
      dppVim9State = "${config.home.homeDirectory}/.cache/dpp_vim9/vim";
    in
    lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      [[ -d ${dppNvimState} ]] && rm -rf ${dppNvimState}
      [[ -d ${dppVim9State} ]] && rm -rf ${dppVim9State}
    '';
}
