#!/bin/bash
# startup denops shared server.
#deno run -A --no-check ./denops/@denops-private/cli.ts
denops_path=~/.cache/dein/repos/github.com/vim-denops/denops.vim
denops_cli=/denops/@denops-private/cli.ts

if [[ $(command -v deno) && -d $denops_path ]]; then
  deno run -A --no-check $denops_path$denops_cli
fi
