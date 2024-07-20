-- lua_add {{{
local opt = { silent = true, noremap = false }
require("user.utils").keymaps_set({
    { mode = { "n", "x", "o" }, lhs = [[f]], rhs = [[<Plug>(eft-f-repeatable)]], opts = opt },
    { mode = { "n", "x", "o" }, lhs = [[F]], rhs = [[<Plug>(eft-F-repeatable)]], opts = opt },
    { mode = { "n", "x", "o" }, lhs = [[t]], rhs = [[<Plug>(eft-t-repeatable)]], opts = opt },
    { mode = { "n", "x", "o" }, lhs = [[T]], rhs = [[<Plug>(eft-T-repeatable)]], opts = opt },
    { mode = { "n", "x", "o" }, lhs = [[;]], rhs = [[<Plug>(eft-repeat)]], opts = opt },
})
-- }}}

-- lua_source {{{
vim.g.eft_ignorecase = true
-- }}}
