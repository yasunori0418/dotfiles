-- lua_add {{{
local opt = {silent = true, noremap = false}
require('user.utils').keymaps_set{
  { mode = {"n", "x"}, lhs = [[tx]], rhs = [[<Plug>(Translate)]], opts = opt },
  { mode = {"n", "x"}, lhs = [[tX]], rhs = [[<Plug>(Translate-reverse)]], opts = opt },
}
-- }}}
