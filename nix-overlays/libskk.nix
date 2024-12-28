(final: prev: {
  # refer: https://github.com/NixOS/nixpkgs/pull/368546
  #        https://nixpk.gs/pr-tracker.html?pr=368546
  libskk = prev.libskk.overrideAttrs (oldAttrs: rec {
    pname = "libskk";
    version = "1.0.5";
    src = prev.fetchFromGitHub {
      owner = "ueno";
      repo = "libskk";
      tag = version;
      hash = "sha256-xXed7mQqseefIldGjNsQf8n0YTcI9L9T1FkO/dhNR3g=";
    };

    env = {
      NIX_CFLAGS_COMPILE = toString [
        "-Wno-error=int-conversion"
      ];
    };
  });
})
