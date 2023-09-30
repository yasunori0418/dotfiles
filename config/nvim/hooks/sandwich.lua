-- lua_add {{{
vim.g.sandwich_no_default_key_mappings = true

local opt = { silent = true, noremap = false }
require("user.utils").keymaps_set({
    { mode = { "n", "x", "o" }, lhs = [[sa]], rhs = [[<Plug>(sandwich-add)]], opts = opt },
    { mode = { "n", "x" }, lhs = [[sd]], rhs = [[<Plug>(sandwich-delete)]], opts = opt },
    { mode = { "n", "x" }, lhs = [[sdb]], rhs = [[<Plug>(sandwich-delete-auto)]], opts = opt },
    { mode = { "n", "x" }, lhs = [[sr]], rhs = [[<Plug>(sandwich-replace)]], opts = opt },
    { mode = { "n", "x" }, lhs = [[srb]], rhs = [[<Plug>(sandwich-replace-auto)]], opts = opt },
})
-- }}}
