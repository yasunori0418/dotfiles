{ inputs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      inputs.claude-code-overlay.overlays.default
      (inputs.vim-overlay.overlays.features {
        lua = true;
        python3 = true;
        ruby = true;
        sodium = true;
      })
    ];
  };
}
