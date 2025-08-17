pkgs:
let
  inherit (pkgs.lib)
    getAttrs
    attrValues
    ;
  inherit (builtins)
    foldl'
    ;
  concat = list: foldl' (item: acc: acc ++ item) [ ] list;
  f = targetNames: attrSet: attrSet |> getAttrs targetNames |> attrValues |> concat;
in
f
