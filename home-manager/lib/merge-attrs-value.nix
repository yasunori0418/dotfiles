pkgs:
let
  inherit (pkgs.lib)
    getAttrs
    attrValues
    ;
  inherit (builtins)
    foldl'
    ;
  merge = list: foldl' (item: acc: acc ++ item) [ ] list;
  f = targetNames: attrSets: attrSets |> getAttrs targetNames |> attrValues |> merge;
in
f
