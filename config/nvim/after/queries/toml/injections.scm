;; extends
;; https://github.com/Shougo/shougo-s-github
;; Original setting get from ↑.
((pair
  (bare_key) @_key
  (string) @vim)
 (#vim-match? @_key "^hook_\w*")
 (#offset! @vim 0 3 0 -3))
((pair
  (bare_key) @_key
  (string) @vim)
 (#vim-match? @_key "^hook_\w*")
 (#vim-match? @vim "^('[^']|\"[^\"])")
 (#offset! @vim 0 1 0 -1))
((pair
  (bare_key) @_key
  (string) @lua)
 (#vim-match? @_key "^lua_\w*")
 (#offset! @lua 0 3 0 -3))
((pair
  (bare_key) @_key
  (string) @lua)
 (#vim-match? @_key "^lua_\w*")
 (#vim-match? @lua "^('[^']|\"[^\"])")
 (#offset! @lua 0 1 0 -1))
((table
  (bare_key) @_key
  (pair
   (string) @vim))
 (#eq? @_key "ftplugin")
 (#offset! @vim 0 3 0 -3))
((table
  (dotted_key) @_key
  (pair
   (string) @vim))
 (#eq? @_key "plugins.ftplugin")
 (#offset! @vim 0 3 0 -3))
