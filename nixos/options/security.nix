{
  config,
  lib,
  pkgs,
  ...
}:
let
  bundle = config.environment.etc."ssl/certs/ca-certificates.crt".source;
  # eMudhra 中間証明書の侵害 (nixpkgs#576485) で不信任化されるべきルート
  distrusted = [
    "Comodo AAA Services root"
    "emSign ECC Root CA - G3"
    "emSign Root CA - C1"
    "emSign ECC Root CA - C3"
  ];
in
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

  system.checks = [
    (pkgs.runCommand "check-distrusted-ca" { } ''
      for name in ${lib.escapeShellArgs distrusted}; do
        if grep -A1 -Fx -- "$name" ${bundle} | grep -qF -- '-----BEGIN CERTIFICATE-----'; then
          echo "error: CA bundle still trusts '$name'" >&2
          exit 1
        fi
      done
      touch $out
    '')
  ];
}
