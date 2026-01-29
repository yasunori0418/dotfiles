{ inputs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ inputs.claude-code-overlay.overlays.default ];
  };
}
