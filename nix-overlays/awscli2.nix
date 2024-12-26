# refer: https://github.com/NixOS/nixpkgs/pull/367979
(final: prev: {
  awscli2 = prev.awscli2.overrideAttrs (oldAttrs: rec {
    pname = "awscli2";
    version = "2.22.13"; # N.B: if you change this, check if overrides are still up-to-date
    src = prev.fetchFromGitHub {
      owner = "aws";
      repo = "aws-cli";
      rev = "refs/tags/${version}";
      hash = "sha256-yrkGfD2EBPsNRLcafdJE4UnYsK7EAfIA7TLa6smmWjY=";
    };

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail 'flit_core>=3.7.1,<3.9.1' 'flit_core>=3.7.1' \
        --replace-fail 'awscrt>=0.19.18,<=0.22.0' 'awscrt>=0.22.0' \
        --replace-fail 'cryptography>=40.0.0,<43.0.2' 'cryptography>=43.0.0' \
        --replace-fail 'distro>=1.5.0,<1.9.0' 'distro>=1.5.0' \
        --replace-fail 'docutils>=0.10,<0.20' 'docutils>=0.10' \
        --replace-fail 'prompt-toolkit>=3.0.24,<3.0.39' 'prompt-toolkit>=3.0.24'
      substituteInPlace requirements-base.txt \
        --replace-fail "wheel==0.43.0" "wheel>=0.43.0"
      # Upstream needs pip to build and install dependencies and validates this
      # with a configure script, but we don't as we provide all of the packages
      # through PYTHONPATH
      sed -i '/pip>=/d' requirements/bootstrap.txt
    '';

  });
})
