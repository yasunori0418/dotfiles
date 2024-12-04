{
  system.userActivationScripts = {
    dppCacheClear = {
      text = ''
        rm -rf /home/yasunori/.cache/dpp/nvim
        rm -rf /home/yasunori/.cache/dpp_vim9/vim
      '';
      deps = [ ];
    };
  };
}
