pkgs:
let
  inherit (pkgs.lib)
    getAttrs
    attrValues
    ;
  inherit (builtins)
    foldl'
    ;
in
{
  /**
    # Example

    ```nix
    let
      listInList = [
        [
          "a"
          "b"
          "c"
        ]
        [
          "d"
          "e"
          "f"
        ]
      ];
    in
    concatOfList listInList
    => ["a" "b" "c" "d" "e" "f"]
    ```

    # Type

    ```
    concatOfList :: [[a]] -> [a]
    ```

    # Arguments

    list :: [[a]]
    : List in list values
  */
  concatOfList = list: foldl' (item: acc: item ++ acc) [ ] list;

  /**
    # Example

    ```nix
    let
      listInAttrs = [
        {
          a = "a";
          b = "b";
          c = "c";
        }
        {
          d = "d";
          e = "e";
          f = "f";
        }
      ];
    in
    concatOfAttrs listInAttrs
    => {
      a = "a";
      b = "b";
      c = "c";
      d = "d";
      e = "e";
      f = "f";
    }
    ```

    # Type

    ```
    concatOfList :: [AttrSet] -> AttrSet
    ```

    # Arguments

    attrs :: [AttrSet]
    : List in attrset values
  */
  concatOfAttrs = attrs: foldl' (item: acc: item // acc) { } attrs;

  /**
    # Example

    ```nix
    let
      attr = {
        abc = ["a" "b" "c"];
        def = ["d" "e" "f"];
        ghi = ["g" "h" "i"];
        jkl = ["j" "k" "l"];
      };
    in
    targetAttrsValue ["abc" "ghi"] attr
    => [["a" "b" "c"] ["g" "h" "i"]]
    ```

    # Type

    ```
    targetAttrsValue :: [String] -> AttrSet [a] -> [[a]]
    ```

    # Arguments

    targetNames :: [String]
    : List of names of AttrSets to be retrieved

    attrSet :: AttrSet [a]
    : The original AttrSet
  */
  targetAttrsValue =
    targetNames: attrSet: attrSet |> getAttrs targetNames |> attrValues;

  attrSetsInList = {
    abc = [
      "a"
      "b"
      "c"
    ];
    def = [
      "d"
      "e"
      "f"
    ];
    ghi = [
      "g"
      "h"
      "i"
    ];
    jkl = [
      "j"
      "k"
      "l"
    ];
  };

  attrSetsInAttrSet = {
    abc = {
      a = "a";
      b = "b";
      c = "c";
    };
    def = {
      d = "d";
      e = "e";
      f = "f";
    };
    ghi = {
      g = "g";
      h = "h";
      i = "i";
    };
    jkl = {
      j = "j";
      k = "k";
      l = "l";
    };
  };
}
