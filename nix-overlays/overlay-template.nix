# refer:
# https://nixos.wiki/wiki/Overlays
# https://github.com/NixOS/nixpkgs/pull/{id}
# https://nixpk.gs/pr-tracker.html?pr={id}
final: prev: {
  hoge = prev.hoge.overrideAttrs (oldAttrs: {
  });
}
