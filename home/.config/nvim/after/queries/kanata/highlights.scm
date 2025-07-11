; comments
(line_comment) @comment.line

(block_comment) @comment.block

; parentheses
[
  "("
  ")"
] @punctuation.bracket

; any declaration
(list
  .
  (unquoted_item) @keyword
  (#match? @keyword
    "platform|def(alias|aliasenvcond|cfg|chords|chordsv2-experimental|fakekeys|layer|layermap|localkeys-(win|winiov2|wintercept|linux|macos)|overrides|seq|src|template|var|virtualkeys)"))

; named declarations - layers
(list
  .
  ((unquoted_item) @_
    (#eq? @_ "deflayer")
    .
    (unquoted_item) @namespace))

; named declarations - layermaps
(list
  .
  ((unquoted_item) @_
    (#eq? @_ "deflayermap")
    .
    (list
      (unquoted_item) @namespace)))

; includes
(list
  .
  (unquoted_item) @keyword.control.import
  (#eq? @keyword.control.import "include")
  .
  [
    (quoted_item)
    (unquoted_item)
  ] @string.special.path)

; platform name
(list
  .
  ((unquoted_item) @_
    (#eq? @_ "platform")
    .
    (list
      (unquoted_item) @namespace)))

; functions
(list
  (list
    .
    (unquoted_item) @function.builtin
    (_)))

; strings
(quoted_item) @string

; aliases
((unquoted_item) @string.special.symbol
  ; @see https://github.com/postsolar/tree-sitter-kanata/issues/1
  (#match? @string.special.symbol "\\V@\\.\\+"))

; variables
((unquoted_item) @variable
  (#match? @variable "\\$.+"))
