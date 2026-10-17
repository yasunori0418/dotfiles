# profile `vim`: nvim / dpp / vim / ideavim と nixpkgs 由来の treesitter parser。
{
  pkgs,
  xdgConfigMap,
  ...
}:
let
  # treesitter パーサーを nixpkgs（dotfiles 自身の pin）の
  # vimPlugins.nvim-treesitter-parsers から symlinkJoin で束ねる。
  # クエリは dpp 管理の nvim-treesitter checkout 側を使う
  # （hooks/treesitter.lua の initialize() が install_dir へ symlink）ため配置しない。
  # パーサーの更新は `nix flake update nixpkgs` + switch。
  nvimTreesitterParsers =
    parsers:
    pkgs.symlinkJoin {
      name = "nvim-treesitter-parsers";
      paths = map (parser: pkgs.vimPlugins.nvim-treesitter-parsers.${parser}) parsers;
    };
in
{
  common =
    xdgConfigMap [
      # keep-sorted start
      "dpp"
      "ideavim"
      "nvim"
      "vim"
      # keep-sorted end
    ]
    // {
      # treesitter parser だけは ~/dotfiles ではなく nix store 由来のため、root 相対
      # symlink ではなく store-backed src（derivation + subpath）で配置する。
      ".local/share/nvim/treesitter/parser" = {
        src = nvimTreesitterParsers [
          # keep-sorted start
          "bash"
          "comment"
          "css"
          "csv"
          "diff"
          "dockerfile"
          "fish"
          "git_config"
          "git_rebase"
          "gitattributes"
          "gitcommit"
          "gitignore"
          "html"
          "jsdoc"
          "json"
          "json5"
          # "jsonc"
          "kdl"
          "kotlin"
          "lua"
          "luadoc"
          "make"
          "markdown"
          "markdown_inline"
          "nix"
          "python"
          "regex"
          "ron"
          "rust"
          "sql"
          "sway"
          "toml"
          "tsv"
          "typescript"
          "vim"
          "vimdoc"
          "xml"
          "yaml"
          # keep-sorted end
        ];
        subpath = "parser";
      };
    };
  MacOS = { };
  Linux = { };
}
