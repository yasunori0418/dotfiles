(final: prev: {
  sheldon =
    let
      sheldon-src = prev.fetchFromGitHub {
        owner = "rossmacarthur";
        repo = "sheldon";
        rev = "9836ef98ca2b44f781deafb409028d4dda7fef17";
        hash = "sha256-eyfIPO1yXvb+0SeAx+F6/z5iDUA2GfWOiElfjn6abJM=";
      };
    in
    prev.sheldon.overrideAttrs (oldAttrs: {
      version = "0.8.0";
      src = sheldon-src;
      cargoDeps = oldAttrs.cargoDeps.overrideAttrs {
        src = sheldon-src;
        name = "sheldon-0.8.0-vendor.tar.gz";
        outputHash = "sha256-+yTX1wUfVVjsM42X0QliL+0xbzTPheADZibPh/5Czh8=";
      };
    });
})
