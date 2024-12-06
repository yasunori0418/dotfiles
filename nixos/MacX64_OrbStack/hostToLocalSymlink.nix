{ config, ... }:
{
  system.userActivationScripts = {
    hostToOrbMachineSymlink = {
      text =
        let
          macHomeDir = "/mnt/mac/Users/watanabe";
          nixHomeDir = config.users.users.yasunori.home;
        in
        ''
          if [[ ! -L ${nixHomeDir}/dotfiles ]]; then
            rm -rf ${nixHomeDir}/dotfiles
          fi
          if [[ ! -L ${nixHomeDir}/src ]]; then
            rm -rf ${nixHomeDir}/src
          fi
          if [[ ! -L ${nixHomeDir}/.ssh ]]; then
            rm -rf ${nixHomeDir}/.ssh
          fi
          ln -svf ${macHomeDir}/dotfiles ${nixHomeDir}/
          ln -svf ${macHomeDir}/src ${nixHomeDir}/
          ln -svf ${macHomeDir}/.ssh ${nixHomeDir}/
        '';
      deps = [ ];
    };
  };
}
