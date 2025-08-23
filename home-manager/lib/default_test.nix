let
  pkgs = import <nixpkgs> { };
  lib = import ./. pkgs;
in
[
  {
    name = "Concatenates multiple arrays within a double array into a single array.";
    actual =
      let
        testData = [
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
      lib.concatOfList testData;
    expected = [
      "a"
      "b"
      "c"
      "d"
      "e"
      "f"
    ];
  }
  {
    name = "Concatenates multiple attrset within a attrset into a single attrset.";
    actual =
      let
        testData = [
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
      lib.concatOfAttrs testData;
    expected = {
      a = "a";
      b = "b";
      c = "c";
      d = "d";
      e = "e";
      f = "f";
    };
  }
]
