{
  security = {
    rtkit.enable = true;
    polkit = {
      enable = true;
      # gparted 等が pkexec を使うため。nixpkgs では既定で setuid wrapper が作られない
      enablePkexecWrapper = true;
    };
    soteria.enable = true;
  };
}
