{ inputs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      inputs.claude-code-overlay.overlays.default
      (inputs.vim-overlay.lib.features {
        cscope = true;
        lua = true;
        python3 = true;
        ruby = true;
        sodium = true;
      })
    ];
  };
}
