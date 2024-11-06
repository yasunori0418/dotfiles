(final: prev: {
  screen = prev.screen.overrideAttrs (oldAttrs: rec {
    version = "5.0.0";
    src = prev.fetchurl {
      url = "mirror://gnu/screen/screen-${version}.tar.gz";
      hash = "sha256-8Eo50AoOXHyGpVM4gIkDCCrV301z3xov00JZdq7ZSXE=";
    };
    configureFlags = [
      "--enable-pam"
      "--enable-utmp"
      "--enable-telnet"
      "--with-system_screenrc=/etc/screenrc"
    ];
    doCheck = false;
  });
})
