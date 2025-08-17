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
/**
  # Example

  ```nix
  let
    attr = {
      abc = ["a" "b" "c"]
      def = ["d" "e" "f"]
      ghi = ["g" "h" "i"]
      jkl = ["j" "k" "l"]
    };
  in
  concatTargetAttrsValue ["abc" "ghi"] attr
  => ["a" "b" "c" "g" "h" "i"]
  ```

  # Type

  ```
  concatTargetAttrsValue :: [String] -> AttrSet [a] -> [a]
  ```

  # Arguments

  targetNames :: [String]
  : List of names of AttrSets to be retrieved

  attrSet :: AttrSet [a]
  : The original AttrSet
*/
f
